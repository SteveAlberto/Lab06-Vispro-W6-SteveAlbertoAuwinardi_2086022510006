import 'package:flutter/material.dart';

import 'models/loan.dart';
import 'models/repo/book_repository.dart';
import 'models/repo/loan_repository.dart';
import 'models/service/book_service.dart';
import 'viewmodels/library_view_model.dart';
import 'views/borrowed_books_screen.dart';
import 'views/library_screen.dart';

const bool seedDemoLoans = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bookRepo = BookRepository(BookService());
  final loanRepo = LoanRepository();
  await bookRepo.load();

  if (seedDemoLoans) _seedDemoLoans(bookRepo, loanRepo);

  runApp(LibraryApp(bookRepo: bookRepo, loanRepo: loanRepo));
}

void _seedDemoLoans(BookRepository books, LoanRepository loans) {
  final today = DateTime.now();
  final dueDates = <String, DateTime>{
    'B001': today.subtract(const Duration(days: 7)),
    'B002': today.subtract(const Duration(days: 14)),
    'B003': DateTime(today.year, today.month - 6, today.day),
  };

  var n = 1;
  dueDates.forEach((bookId, due) {
    final book = books.findById(bookId);
    if (book == null) return;
    loans.add(
      Loan(
        id: 'SEED$n',
        bookId: bookId,
        studentId: 'S001',
        borrowDate: due.subtract(const Duration(days: FinePolicy.loanDays)),
        dueDate: due,
      ),
    );
    books.update(book.copyWith(isAvailable: false));
    n++;
  });
}

class LibraryApp extends StatefulWidget {
  const LibraryApp({super.key, required this.bookRepo, required this.loanRepo});
  final BookRepository bookRepo;
  final LoanRepository loanRepo;

  @override
  State<LibraryApp> createState() => _LibraryAppState();
}

class _LibraryAppState extends State<LibraryApp> {
  late final LibraryViewModel _libraryVm;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _libraryVm = LibraryViewModel(widget.bookRepo, widget.loanRepo);
  }

  @override
  void dispose() {
    _libraryVm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Library',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        body: IndexedStack(
          index: _tab,
          children: [
            LibraryScreen(viewModel: _libraryVm),
            BorrowedBooksScreen(viewModel: _libraryVm),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book),
              label: 'Peminjaman',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_return),
              label: 'Pengembalian',
            ),
          ],
        ),
      ),
    );
  }
}
