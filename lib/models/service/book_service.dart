import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../book.dart';

class BookService {
  Future<List<Book>> fetchBooks() async {
    final raw = await rootBundle.loadString('books.json');
    final List<dynamic> list = jsonDecode(raw);
    return list.map((item) => Book.fromJson(item)).toList();
  }
}
