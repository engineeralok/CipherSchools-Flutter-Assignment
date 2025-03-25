import 'package:flutter/material.dart';
import '../core/database.dart';
import '../models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper _db =
      DatabaseHelper(); // Keep local database as fallback
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Transaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;
  String _selectedFilter = 'Today'; // Default filter
  bool _useFirestore = true; // Flag to determine if Firestore should be used

  List<Transaction> get transactions {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Today':
        return _transactions
            .where(
              (t) =>
                  t.timestamp.year == now.year &&
                  t.timestamp.month == now.month &&
                  t.timestamp.day == now.day,
            )
            .toList();
      case 'Week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return _transactions
            .where(
              (t) =>
                  t.timestamp.isAfter(
                    weekStart.subtract(const Duration(days: 1)),
                  ) &&
                  t.timestamp.isBefore(weekEnd.add(const Duration(days: 1))),
            )
            .toList();
      case 'Month':
        return _transactions
            .where(
              (t) =>
                  t.timestamp.year == now.year &&
                  t.timestamp.month == now.month,
            )
            .toList();
      case 'Year':
        return _transactions
            .where((t) => t.timestamp.year == now.year)
            .toList();
      default:
        return _transactions;
    }
  }

  List<Transaction> get allTransactions => _transactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance {
    double periodIncome = 0;
    double periodExpense = 0;
    for (var transaction in transactions) {
      if (transaction.type == 'income') {
        periodIncome += transaction.amount;
      } else {
        periodExpense += transaction.amount;
      }
    }
    return periodIncome + periodExpense;
  }

  Future<void> loadTransactions() async {
    try {
      if (_useFirestore && _auth.currentUser != null) {
        // Try to load from Firestore first
        final userId = _auth.currentUser!.uid;
        final snapshot =
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('transactions')
                .orderBy('timestamp', descending: true)
                .get();

        if (snapshot.docs.isNotEmpty) {
          _transactions =
              snapshot.docs.map((doc) {
                final data = doc.data();
                // Add the document ID as the transaction ID
                return Transaction.fromMap({...data, 'id': doc.id});
              }).toList();

          // Calculate totals
          _totalIncome = 0;
          _totalExpense = 0;
          for (var transaction in _transactions) {
            if (transaction.type == 'income') {
              _totalIncome += transaction.amount;
            } else {
              _totalExpense += transaction.amount;
            }
          }
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading from Firestore: $e');
      // Fall back to local database
      _useFirestore = false;
    }

    // Fallback to local database
    final transactionMaps = await _db.getTransactions();
    _transactions =
        transactionMaps.map((map) => Transaction.fromMap(map)).toList();
    _totalIncome = await _db.getTotalIncome();
    _totalExpense = await _db.getTotalExpense();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    Transaction newTransaction;

    try {
      if (_useFirestore && _auth.currentUser != null) {
        // Try to add to Firestore first
        final userId = _auth.currentUser!.uid;
        final transactionMap = transaction.toMap();
        // Remove id as Firestore will generate one
        transactionMap.remove('id');

        final docRef = await _firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .add(transactionMap);

        newTransaction = Transaction(
          id: docRef.id,
          title: transaction.title,
          subtitle: transaction.subtitle,
          amount: transaction.amount,
          type: transaction.type,
          category: transaction.category,
          icon: transaction.icon,
          iconBackgroundColor: transaction.iconBackgroundColor,
          timestamp: transaction.timestamp,
        );
      } else {
        // Fallback to local database
        final id = await _db.insertTransaction(transaction.toMap());
        newTransaction = Transaction(
          id: id.toString(),
          title: transaction.title,
          subtitle: transaction.subtitle,
          amount: transaction.amount,
          type: transaction.type,
          category: transaction.category,
          icon: transaction.icon,
          iconBackgroundColor: transaction.iconBackgroundColor,
          timestamp: transaction.timestamp,
        );
      }
    } catch (e) {
      debugPrint('Error adding transaction to Firestore: $e');
      // Fallback to local database
      _useFirestore = false;
      final id = await _db.insertTransaction(transaction.toMap());

      newTransaction = Transaction(
        id: id.toString(),
        title: transaction.title,
        subtitle: transaction.subtitle,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        icon: transaction.icon,
        iconBackgroundColor: transaction.iconBackgroundColor,
        timestamp: transaction.timestamp,
      );
    }

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
      try {
        if (_useFirestore && _auth.currentUser != null) {
          final userId = _auth.currentUser!.uid;
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('transactions')
              .doc(transaction.id.toString())
              .delete();
        } else {
          await _db.deleteTransaction(transaction.id!);
        }
      } catch (e) {
        debugPrint('Error deleting transaction from Firestore: $e');
        _useFirestore = false;
        await _db.deleteTransaction(transaction.id!);
      }

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

  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }
}
