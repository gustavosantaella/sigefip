import 'package:flutter/material.dart';
import '../../../shared/models/account_model.dart';
import '../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../../core/constants/currencies.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Account> accounts = [
      AppColors_accounts_mock.cash,
      AppColors_accounts_mock.bank,
      AppColors_accounts_mock.savings,
    ];

    double totalBalance = accounts.fold(0, (sum, item) => sum + item.balance);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mis Cuentas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Balance Total: \$${totalBalance.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Accounts Grid/List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: account.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            account.icon,
                            color: account.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${account.balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => const AddAccountForm(),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddAccountForm extends StatefulWidget {
  const AddAccountForm({super.key});

  @override
  State<AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String? _selectedCurrency;
  Color _selectedColor = const Color(0xFF6C63FF);

  final List<Color> _availableColors = [
    const Color(0xFF6C63FF),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFF9800),
    const Color(0xFFF44336),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF00BCD4),
    const Color(0xFF8BC34A),
    const Color(0xFFFFEB3B),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Nueva Cuenta',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Nombre de la cuenta',
            hintText: 'Ej. Banco, Efectivo...',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _balanceController,
            label: 'Saldo Inicial',
            keyboardType: TextInputType.number,
            prefixText: '\$ ',
          ),
          const SizedBox(height: 16),
          CustomDropdown<String>(
            label: 'Moneda',
            value: _selectedCurrency,
            items: currencies,
            itemLabelBuilder: (item) => item,
            onChanged: (val) => setState(() => _selectedCurrency = val),
          ),
          const SizedBox(height: 20),
          const Text(
            'Color de la cuenta',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final color = _availableColors[index];
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: 'Guardar Cuenta',
            onPressed: () {
              // Logic to save
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class AppColors_accounts_mock {
  static const Account cash = Account(
    id: '1',
    name: 'Efectivo',
    balance: 15430.00,
    icon: Icons.money,
    color: Color(0xFF4CAF50),
  );

  static const Account bank = Account(
    id: '2',
    name: 'Banco Principal',
    balance: 45000.00,
    icon: Icons.account_balance,
    color: Color(0xFF2196F3),
  );

  static const Account savings = Account(
    id: '3',
    name: 'Ahorros',
    balance: 12000.00,
    icon: Icons.savings,
    color: Color(0xFFFF9800),
  );
}
