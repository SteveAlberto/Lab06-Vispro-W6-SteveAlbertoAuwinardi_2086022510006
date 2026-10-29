import 'package:flutter/material.dart';

import '../../models/loan.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.loan,
    required this.bookTitle,
    required this.status,
    required this.fine,
    required this.onReturn,
  });
  final Loan loan;
  final String bookTitle;
  final LoanStatus status;
  final int fine;
  final VoidCallback onReturn;

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String get _statusLabel => switch (status) {
    LoanStatus.borrowed => 'Dipinjam',
    LoanStatus.overdue => 'Terlambat',
    LoanStatus.missing => 'Hilang (Missing)',
    LoanStatus.returned => 'Dikembalikan',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(bookTitle),
        subtitle: Text(
          'Jatuh tempo: ${_date(loan.dueDate)}\nStatus: $_statusLabel\nDenda: Rp$fine',
        ),
        isThreeLine: true,
        trailing: loan.isActive
            ? FilledButton(onPressed: onReturn, child: const Text('Return'))
            : null,
      ),
    );
  }
}
