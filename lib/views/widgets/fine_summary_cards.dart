import 'package:flutter/material.dart';

class FineSummaryCards extends StatelessWidget {
  const FineSummaryCards({
    super.key,
    required this.activeCount,
    required this.overdueCount,
    required this.totalFine,
  });
  final int activeCount;
  final int overdueCount;
  final int totalFine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _Item(label: 'Dipinjam', value: '$activeCount'),
          _Item(label: 'Terlambat', value: '$overdueCount'),
          _Item(label: 'Total denda', value: 'Rp$totalFine'),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(value, style: Theme.of(context).textTheme.titleMedium),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
