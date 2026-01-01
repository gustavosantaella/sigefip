import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/models/base_model.dart';

class Account {
  String? id;
  String name;
  double balance;
  final String? currency;
  final IconData icon;
  final Color color;

  Account({
    this.id,
    required this.name,
    required this.balance,
    required this.currency,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'icon': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': icon.fontPackage,
      'color': color.value,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'] ?? '',
      balance: (map['balance'] ?? 0.0).toDouble(),
      currency: map['currency'],
      icon: IconData(
        map['icon'] ?? 0,
        fontFamily: map['fontFamily'],
        fontPackage: map['fontPackage'],
      ),
      color: Color(map['color'] ?? 0xFF6C63FF),
    );
  }
}
