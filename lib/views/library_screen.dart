import 'package:flutter/material.dart';

import '../viewmodels/library_view_model.dart';
import 'widgets/book_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key, required this.viewModel});
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final books = viewModel.books;
        return Scaffold(
          appBar: AppBar(title: const Text('Katalog Buku')),
          body: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, i) {
              final book = books[i];
              return BookCard(
                book: book,
                onBorrow: () async {
                  final controller = TextEditingController();
                  final studentId = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Pinjam: ${book.title}'),
                      content: TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'ID Mahasiswa',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, controller.text),
                          child: const Text('Pinjam'),
                        ),
                      ],
                    ),
                  );
                  if (studentId == null) return;

                  final error = viewModel.borrowBook(book.id, studentId);
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)));
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
