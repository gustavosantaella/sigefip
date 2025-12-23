import 'package:flutter/material.dart';
import '../../shared/widgets/transactions.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Buscar transacciones...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(label: 'Todas', isSelected: true),
                          const SizedBox(width: 12),
                          _FilterChip(label: 'Ingresos', isSelected: false),
                          const SizedBox(width: 12),
                          _FilterChip(label: 'Egresos', isSelected: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Transaction List
                    TransactionCard(
                      title: 'Cine y cena',
                      category: 'Entretenimiento',
                      account: 'Cuenta Principal',
                      date: '17 dic 2024',
                      amount: '-60,00 US\$',
                      color: Colors.purple,
                      icon: Icons.games_outlined,
                      isExpense: true,
                    ),
                    const SizedBox(height: 12),
                    TransactionCard(
                      title: 'Uber',
                      category: 'Transporte',
                      account: 'Cuenta Principal',
                      date: '15 dic 2024',
                      amount: '-20,00 US\$',
                      color: Colors.redAccent,
                      icon: Icons.directions_car_outlined,
                      isExpense: true,
                    ),
                    const SizedBox(height: 12),
                    TransactionCard(
                      title: 'Almuerzo',
                      category: 'Comida',
                      account: 'Cuenta Principal',
                      date: '14 dic 2024',
                      amount: '-45,50 US\$',
                      color: Colors.orange,
                      icon: Icons.lunch_dining_outlined,
                      isExpense: true,
                    ),
                    const SizedBox(height: 12),
                    TransactionCard(
                      title: 'Proyecto freelance',
                      category: 'Freelance',
                      account: 'Ahorros',
                      date: '9 dic 2024',
                      amount: '+500,00 US\$',
                      color: Colors.brown,
                      icon: Icons.work_outline,
                      isExpense: false,
                    ),
                    const SizedBox(height: 12),
                    TransactionCard(
                      title: 'Salario mensual',
                      category: 'Salario',
                      account: 'Cuenta Principal',
                      date: '30 nov 2024',
                      amount: '+3000,00 US\$',
                      color: Colors.amber,
                      icon: Icons.attach_money,
                      isExpense: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: Colors.white10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
