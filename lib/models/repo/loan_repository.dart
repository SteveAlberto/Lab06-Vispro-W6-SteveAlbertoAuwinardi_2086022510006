import 'package:flutter/foundation.dart';

import '../loan.dart';

class LoanRepository extends ChangeNotifier {
  final List<Loan> _loans = [];

  List<Loan> get loans => List.unmodifiable(_loans);

  void add(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }

  void update(Loan loan) {
    final index = _loans.indexWhere((item) => item.id == loan.id);
    if (index != -1) {
      _loans[index] = loan;
      notifyListeners();
    }
  }

  Loan? findById(String id) {
    for (final item in _loans) {
      if (item.id == id) return item;
    }
    return null;
  }
}
