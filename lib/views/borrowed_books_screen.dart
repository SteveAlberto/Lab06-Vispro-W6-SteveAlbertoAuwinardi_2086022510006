import 'package:flutter/material.dart';

import '../viewmodels/library_view_model.dart';
import 'widgets/fine_summary_cards.dart';
import 'widgets/loan_card.dart';

class BorrowedBooksScreen extends StatelessWidget {
  const BorrowedBooksScreen({super.key, required this.viewModel});
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final loans = viewModel.loans;
        return Scaffold(
          appBar: AppBar(title: const Text('Pengembalian')),
          body: Column(
            children: [
              FineSummaryCards(
                activeCount: viewModel.activeLoans.length,
                overdueCount: viewModel.overdueLoans.length,
                totalFine: viewModel.totalFine,
              ),
              Expanded(
                child: loans.isEmpty
                    ? const Center(child: Text('Belum ada peminjaman'))
                    : ListView.builder(
                        itemCount: loans.length,
                        itemBuilder: (context, i) {
                          final loan = loans[i];
                          return LoanCard(
                            loan: loan,
                            bookTitle:
                                viewModel.bookOf(loan)?.title ?? loan.bookId,
                            status: viewModel.getOverdueStatus(loan),
                            fine: viewModel.calculateFine(loan),
                            onReturn: () {
                              final error = viewModel.returnBook(loan.id);
                              if (error != null) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
