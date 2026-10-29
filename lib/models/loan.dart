class Loan {
  final String id;
  final String bookId;
  final String studentId;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;

  const Loan({
    required this.id,
    required this.bookId,
    required this.studentId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
  });

  bool get isActive => returnDate == null;

  Loan copyWith({DateTime? returnDate}) => Loan(
    id: id,
    bookId: bookId,
    studentId: studentId,
    borrowDate: borrowDate,
    dueDate: dueDate,
    returnDate: returnDate ?? this.returnDate,
  );
}

class FinePolicy {
  static const int finePerWeek = 5000;
  static const int daysPerWeek = 7;
  static const int loanDays = 7;
  static const int missingAfterMonths = 6;
}

enum LoanStatus { borrowed, overdue, missing, returned }
