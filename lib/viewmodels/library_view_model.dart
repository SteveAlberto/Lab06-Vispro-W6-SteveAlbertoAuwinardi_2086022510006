import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../models/loan.dart';
import '../models/repo/book_repository.dart';
import '../models/repo/loan_repository.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel(this._books, this._loans, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final BookRepository _books;
  final LoanRepository _loans;
  final DateTime Function() _now;
  int _loanCounter = 0;

  List<Book> get books => _books.books;
  List<Loan> get loans => _loans.loans;

  Book? bookOf(Loan loan) => _books.findById(loan.bookId);

  List<Loan> get activeLoans => _loans.loans.where((l) => l.isActive).toList();

  List<Loan> get overdueLoans => _loans.loans
      .where((l) => getOverdueStatus(l) == LoanStatus.overdue)
      .toList();

  int get totalFine =>
      _loans.loans.fold(0, (sum, loan) => sum + calculateFine(loan));

  String? borrowBook(String bookId, String studentId) {
    final student = studentId.trim();
    if (student.isEmpty) return 'ID mahasiswa wajib diisi';
    final book = _books.findById(bookId);

    if (book == null) return 'Buku tidak ditemukan';

    final hasActiveLoan = _loans.loans.any(
      (l) => l.bookId == bookId && l.isActive,
    );
    if (!book.isAvailable || hasActiveLoan) return 'Buku sedang dipinjam';

    final now = _now();
    _loans.add(
      Loan(
        id: 'L${++_loanCounter}',
        bookId: book.id,
        studentId: student,
        borrowDate: now,
        dueDate: now.add(const Duration(days: FinePolicy.loanDays)),
      ),
    );
    _books.update(book.copyWith(isAvailable: false));

    notifyListeners();
    return null;
  }

  String? returnBook(String loanId) {
    
    final loan = _loans.findById(loanId);
    if (loan == null) return 'Peminjaman tidak ditemukan';
    if (!loan.isActive) return 'Buku sudah dikembalikan';
    _loans.update(loan.copyWith(returnDate: _now()));

    final book = _books.findById(loan.bookId);
    if (book != null) {
      _books.update(book.copyWith(isAvailable: true));
    }

    notifyListeners();
    return null;
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  int _overdueDays(Loan loan) {
    final end = _dateOnly(loan.returnDate ?? _now());
    final due = _dateOnly(loan.dueDate);
    if (!end.isAfter(due)) return 0;
    return end.difference(due).inDays;
  }

  DateTime _missingThreshold(Loan loan) {
    final due = _dateOnly(loan.dueDate);
    return DateTime(
      due.year,
      due.month + FinePolicy.missingAfterMonths,
      due.day,
    );
  }

  bool _isMissing(Loan loan) {
    final end = _dateOnly(loan.returnDate ?? _now());
    return !end.isBefore(_missingThreshold(loan));
  }

  LoanStatus getOverdueStatus(Loan loan) {
    if (_isMissing(loan)) return LoanStatus.missing;
    if (loan.returnDate != null) return LoanStatus.returned;
    if (_overdueDays(loan) > 0) return LoanStatus.overdue;
    return LoanStatus.borrowed;
  }

  int calculateFine(Loan loan) {
    final overdueDays = _overdueDays(loan);
    if (overdueDays <= 0) return 0;

    int totalFine = 0;
    int remainingDays = overdueDays;
    int currentDailyRate = 5000;

    while (remainingDays > 0) {
      int daysInThisTier = remainingDays >= 7 ? 7 : remainingDays;
      totalFine += (daysInThisTier * currentDailyRate);
      remainingDays -= daysInThisTier;
      currentDailyRate += 5000; 
    }

    if (_isMissing(loan)) {
      final book = _books.findById(loan.bookId);
      return totalFine + (book?.replacementPrice ?? 0);
    }

    return totalFine;
  }
}
