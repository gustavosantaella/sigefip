import 'package:flutter/material.dart';

class Budget {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type; // 'Ingreso' or 'Egreso'
  final String concurrency; // 'Diario', 'Semanal', 'Mensual', etc.
  final int? cutoffDay;
  final String? note;
  final IconData icon;
  final Color color;
  final DateTime? startDate;
  final DateTime? endDate;

  final String status; // 'active', 'completed'

  // These are calculated fields, not stored in DB
  double spent;
  double executedAmount; // Actual amount executed (0 if postponed)

  Budget({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.concurrency,
    this.cutoffDay,
    this.note,
    required this.icon,
    required this.color,
    this.startDate,
    this.endDate,
    this.status = 'active',
    this.spent = 0.0,
    this.executedAmount = 0.0,
  });

  double get progress => amount > 0 ? (spent / amount).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'concurrency': concurrency,
      'cutoffDay': cutoffDay,
      'note': note,
      'icon': icon.codePoint,
      'color': color.value,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'executedAmount': executedAmount,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      type: map['type'],
      concurrency: map['concurrency'],
      cutoffDay: map['cutoffDay'],
      note: map['note'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      status: map['status'] ?? 'active',
      executedAmount: map['executedAmount'] ?? 0.0,
    );
  }
}
