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

  Alert({
    required this.id,
    required this.category,
    required this.account,
    required this.maxAmount,
    required this.period,
    required this.cutoffDay,
    required this.icon,
    required this.color,
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
    );
  }
}
