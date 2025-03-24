import 'package:flutter/material.dart';
import '../core/database.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Transaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;

  List<Transaction> get transactions => _transactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;

  Future<void> loadTransactions() async {
    final transactionMaps = await _db.getTransactions();
    _transactions =
        transactionMaps.map((map) => Transaction.fromMap(map)).toList();
    _totalIncome = await _db.getTotalIncome();
    _totalExpense = await _db.getTotalExpense();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final id = await _db.insertTransaction(transaction.toMap());
    final newTransaction = Transaction(
      id: id,
      title: transaction.title,
      subtitle: transaction.subtitle,
      amount: transaction.amount,
      type: transaction.type,
      category: transaction.category,
      icon: transaction.icon,
      iconBackgroundColor: transaction.iconBackgroundColor,
      timestamp: transaction.timestamp,
    );

    _transactions.insert(0, newTransaction);
    if (transaction.type == 'income') {
      _totalIncome += transaction.amount;
    } else {
      _totalExpense += transaction.amount;
    }
    notifyListeners();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    if (transaction.id != null) {
      await _db.deleteTransaction(transaction.id!);
      _transactions.removeWhere((t) => t.id == transaction.id);
      if (transaction.type == 'income') {
        _totalIncome -= transaction.amount;
      } else {
        _totalExpense -= transaction.amount;
      }
      notifyListeners();
    }
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  Map<String, double> getCategoryTotals() {
    final totals = <String, double>{};
    for (var transaction in _transactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount.abs();
    }
    return totals;
  }
}
