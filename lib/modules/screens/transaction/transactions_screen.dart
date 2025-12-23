import 'package:flutter/material.dart';
import '../../../shared/widgets/transactions.dart';
import '../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

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
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: const Color(0xFF1E1E1E),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => const AddTransactionForm(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
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

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  String? _selectedCategory;
  String? _selectedAccount;
  String _transactionType = 'Egreso'; // 'Ingreso' or 'Egreso'
  bool _showExtras = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _conversionRateController =
      TextEditingController();

  final List<String> _categories = [
    'Alimentación',
    'Transporte',
    'Servicios',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Salario',
    'Freelance',
    'Otros',
  ];

  final List<String> _accounts = [
    'Cuenta Principal',
    'Ahorros',
    'Efectivo',
    'Tarjeta Crédito',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Nueva Transacción',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title Input
          CustomTextField(controller: _titleController, label: 'Título'),
          const SizedBox(height: 16),

          // Type Selection (Income/Expense)
          Row(
            children: [
              Expanded(
                child: _TypeChip(
                  label: 'Ingreso',
                  isSelected: _transactionType == 'Ingreso',
                  color: Colors.green,
                  onTap: () => setState(() => _transactionType = 'Ingreso'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TypeChip(
                  label: 'Egreso',
                  isSelected: _transactionType == 'Egreso',
                  color: Colors.redAccent,
                  onTap: () => setState(() => _transactionType = 'Egreso'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Account Dropdown
          CustomDropdown<String>(
            label: 'Cuenta',
            value: _selectedAccount,
            items: _accounts,
            itemLabelBuilder: (item) => item,
            onChanged: (val) => setState(() => _selectedAccount = val),
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          CustomDropdown<String>(
            label: 'Categoría',
            value: _selectedCategory,
            items: _categories,
            itemLabelBuilder: (item) => item,
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
          const SizedBox(height: 16),

          // Amount Input
          CustomTextField(
            controller: _amountController,
            label: 'Monto',
            keyboardType: TextInputType.number,
            prefixText: '\$ ',
          ),
          const SizedBox(height: 16),

          // Note Input
          CustomTextField(
            controller: _noteController,
            label: 'Nota (Opcional)',
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Extras Section
          GestureDetector(
            onTap: () => setState(() => _showExtras = !_showExtras),
            child: Row(
              children: [
                Text(
                  'Extras',
                  style: TextStyle(
                    color: _showExtras ? const Color(0xFF6C63FF) : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _showExtras
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: _showExtras ? const Color(0xFF6C63FF) : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),

          if (_showExtras) ...[
            const SizedBox(height: 16),
            CustomTextField(
              controller: _conversionRateController,
              label: 'Tasa de Conversión',
              keyboardType: TextInputType.number,
            ),
          ],

          const SizedBox(height: 30),

          // Save Button
          CustomButton(
            text: 'Guardar Transacción',
            onPressed: () {
              // Logic to save transaction
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
