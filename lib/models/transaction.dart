import 'package:flutter/material.dart';

class Transaction {
  final int? id;
  final String title;
  final String subtitle;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final IconData icon;
  final Color iconBackgroundColor;
  final DateTime timestamp;

  Transaction({
    this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.category,
    required this.icon,
    required this.iconBackgroundColor,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'type': type,
      'category': category,
      'icon': icon.codePoint,
      'iconBackgroundColor': iconBackgroundColor.toARGB32(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      amount: map['amount'] as double,
      type: map['type'] as String,
      category: map['category'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      iconBackgroundColor: Color(map['iconBackgroundColor'] as int),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }
}
