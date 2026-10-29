import 'package:flutter/foundation.dart';

import '../book.dart';
import '../service/book_service.dart';

class BookRepository extends ChangeNotifier {
  BookRepository(this._service);
  final BookService _service;
  final List<Book> _books = [];

  List<Book> get books => List.unmodifiable(_books);

  Future<void> load() async {
    _books.addAll(await _service.fetchBooks());
    notifyListeners();
  }

  Book? findById(String id) {
    for (final item in _books) {
      if (item.id == id) return item;
    }
    return null;
  }

  void update(Book book) {
    final index = _books.indexWhere((item) => item.id == book.id);
    if (index != -1) {
      _books[index] = book;
      notifyListeners();
    }
  }
}
