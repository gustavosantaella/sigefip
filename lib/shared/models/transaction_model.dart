import 'package:flutter/material.dart';

class Transaction {
  String? id;
  final String title;
  final double amount;
  final String category;
  final String account;
  final bool isExpense;
  IconData? icon;
  final DateTime date;
  Color color = Colors.white;
  double conversionRate;
  final String? note;
  final String? imagePath;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    DateTime? date,
    required this.category,
    required this.account,
    required this.isExpense,
    this.icon,
    this.color = Colors.white,
    this.conversionRate = 1.0,
    this.note,
    this.imagePath,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'account': account,
      'isExpense': isExpense,
      'icon': icon?.codePoint,
      'color': color.value,
      'conversionRate': conversionRate,
      'note': note,
      'imagePath': imagePath,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      category: map['category'],
      account: map['account'],
      isExpense: map['isExpense'],
      icon: map['icon'] != null
          ? IconData(map['icon'] as int, fontFamily: 'MaterialIcons')
          : null,
      color: Color(map['color'] ?? Colors.white.value),
      conversionRate: (map['conversionRate'] as num?)?.toDouble() ?? 1.0,
      note: map['note'],
      imagePath: map['imagePath'],
    );
  }
}
