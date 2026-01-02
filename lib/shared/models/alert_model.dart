import 'package:flutter/material.dart';

class Alert {
  final String id;
  final String category;
  final String account;
  final double maxAmount;
  final String period; // 'Mensual', 'Anual'
  final int cutoffDay; // Día de corte (1-31)
  final IconData icon;
  final Color color;
  final bool notified50;
  final bool notified80;
  final bool notified100;

  Alert({
    required this.id,
    required this.category,
    required this.account,
    required this.maxAmount,
    required this.period,
    required this.cutoffDay,
    required this.icon,
    required this.color,
    this.notified50 = false,
    this.notified80 = false,
    this.notified100 = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'account': account,
      'maxAmount': maxAmount,
      'period': period,
      'cutoffDay': cutoffDay,
      'icon': icon.codePoint,
      'color': color.value,
      'notified50': notified50 ? 1 : 0,
      'notified80': notified80 ? 1 : 0,
      'notified100': notified100 ? 1 : 0,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['id'],
      category: map['category'],
      account: map['account'],
      maxAmount: map['maxAmount'],
      period: map['period'],
      cutoffDay: map['cutoffDay'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      notified50: (map['notified50'] ?? 0) == 1,
      notified80: (map['notified80'] ?? 0) == 1,
      notified100: (map['notified100'] ?? 0) == 1,
    );
  }
}
