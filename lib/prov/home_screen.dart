import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  DateTime? _selectedMonth;
  DateTime? get selectedMonth => _selectedMonth;

  void setSelectedMonth(DateTime date) {
    _selectedMonth = date;
    notifyListeners();
  }

  String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
