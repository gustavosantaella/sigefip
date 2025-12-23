import 'package:flutter/material.dart';

class Account {
  final String id;
  final String name;
  final double balance;
  final IconData icon;
  final Color color;

  const Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
  });
}
