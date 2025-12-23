import 'package:flutter/material.dart';

class Budget {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final IconData icon;
  final Color color;

  final String concurrency;

  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.icon,
    required this.color,
    required this.concurrency,
  });

  double get progress => (spent / limit).clamp(0.0, 1.0);
}
