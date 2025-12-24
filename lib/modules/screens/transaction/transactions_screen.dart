import 'package:flutter/material.dart';
import 'package:sigefip/shared/models/account_model.dart';
import 'package:sigefip/shared/models/transaction_model.dart';
import 'package:sigefip/shared/services/offline/account_service.dart';
import 'package:sigefip/shared/services/offline/transaction_service.dart';
import 'package:sigefip/shared/models/category_model.dart';
import 'package:sigefip/shared/services/offline/category_service.dart';
import '../../../shared/widgets/slide_card.dart';
import '../../../shared/widgets/transactions.dart';
import '../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/type_chip.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() async {
    transactions = await TransactionService.getTransactions();
    print("Transactions: ${transactions.length}");
    setState(() {
      transactions = transactions;
    });
  }

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
                            builder: (context) => AddTransactionForm(
                              loadTransactions: loadTransactions,
                            ),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SlideCard<Transaction>(
                              item: transactions[index],
                              borderRadius: BorderRadius.circular(16),
                              rightOptions: [
                                SlideAction<Transaction>(
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  onPressed: (transaction) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Delete ${transaction.title}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SlideAction<Transaction>(
                                  icon: Icons.edit,
                                  color: Colors.yellow,
                                  onPressed: (transaction) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Edit ${transaction.title}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              child: TransactionCard(
                                title: transactions[index].title,
                                category: transactions[index].category,
                                account: transactions[index].account,
                                date: transactions[index].date.toString(),
                                amount: transactions[index].amount.toString(),
                                color: transactions[index].color,
                                icon:
                                    transactions[index].icon ??
                                    (transactions[index].isExpense
                                        ? Icons.remove
                                        : Icons.add),
                                isExpense: transactions[index].isExpense,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
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

class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? error;

  TransactionState({
    required this.transactions,
    required this.isLoading,
    required this.error,
  });
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
  final VoidCallback loadTransactions;

  const AddTransactionForm({super.key, required this.loadTransactions});

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

  List<Category> _allCategories = [];
  List<String> _categories = [];
  List<Account> _allAccounts = [];
  List<String> _accountNames = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    _allAccounts = await AccountService.getAccounts();
    setState(() {
      _accountNames = _allAccounts.map((a) => a.name).toList();
    });
  }

  Future<void> _loadCategories() async {
    _allCategories = await CategoryService.getCategories();
    _updateFilteredCategories();
  }

  void _updateFilteredCategories() {
    setState(() {
      _categories = _allCategories
          .where((cat) => cat.type == _transactionType)
          .map((cat) => cat.name)
          .toList();
      if (_selectedCategory != null &&
          !_categories.contains(_selectedCategory)) {
        _selectedCategory = null;
      }
    });
  }

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
                child: TypeChip(
                  label: 'Ingreso',
                  isSelected: _transactionType == 'Ingreso',
                  color: Colors.green,
                  onTap: () {
                    setState(() => _transactionType = 'Ingreso');
                    _updateFilteredCategories();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TypeChip(
                  label: 'Egreso',
                  isSelected: _transactionType == 'Egreso',
                  color: Colors.redAccent,
                  onTap: () {
                    setState(() => _transactionType = 'Egreso');
                    _updateFilteredCategories();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomDropdown<String>(
            label: 'Cuenta',
            value: _selectedAccount,
            items: _accountNames,
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

          CustomButton(
            text: 'Guardar Transacción',
            onPressed: () async {
              // Find the selected category object to get its icon and color
              final selectedCategoryObj = _allCategories.firstWhere(
                (cat) => cat.name == _selectedCategory,
                orElse: () => Category(
                  id: 'other',
                  name: 'Otros',
                  icon: Icons.category,
                  color: Colors.grey,
                  type: _transactionType,
                ),
              );

              await TransactionService.store(
                Transaction(
                  title: _titleController.text,
                  note: _noteController.text,
                  amount: double.tryParse(_amountController.text) ?? 0.0,
                  category: _selectedCategory ?? 'Otros',
                  account: _selectedAccount ?? 'General',
                  isExpense: _transactionType == 'Egreso',
                  icon: selectedCategoryObj.icon,
                  color: selectedCategoryObj.color,
                  conversionRate:
                      double.tryParse(_conversionRateController.text) ?? 1.0,
                ),
              );
              widget.loadTransactions();
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
