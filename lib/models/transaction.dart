import 'package:cipherschools_flutter_assignment/models/category_icon.dart';
import 'package:flutter/material.dart';

class Transaction {
  final String? id;
  final String title;
  final String subtitle;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final CategoryIcon icon;
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
      'iconData': icon.icon?.codePoint,
      'iconBackgroundColor': iconBackgroundColor.toARGB32(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    dynamic idValue = map['id'];

    double amount;
    if (map['amount'] is int) {
      amount = (map['amount'] as int).toDouble();
    } else {
      amount = map['amount'] as double;
    }

    return Transaction(
      id: idValue,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String? ?? '',
      amount: amount,
      type: map['type'] as String,
      category: map['category'] as String,
      icon: CategoryIcon(
        imagePath: map['imagePath'] as String?,
        icon:
            map['iconData'] != null
                ? IconData(map['iconData'] as int, fontFamily: 'MaterialIcons')
                : null,
      ),
      iconBackgroundColor: Color(map['iconBackgroundColor'] as int),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }
}
