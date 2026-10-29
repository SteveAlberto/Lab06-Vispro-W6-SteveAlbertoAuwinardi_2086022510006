import 'package:flutter/material.dart';

import '../../models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.onBorrow});
  final Book book;
  final VoidCallback onBorrow;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(book.title),
        subtitle: Text(book.author),
        trailing: book.isAvailable
            ? FilledButton(onPressed: onBorrow, child: const Text('Borrow'))
            : const Chip(label: Text('Dipinjam')),
      ),
    );
  }
}
