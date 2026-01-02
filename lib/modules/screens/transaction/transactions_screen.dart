import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexo_finance/shared/services/online/ia_service.dart';
import 'package:nexo_finance/shared/models/account_model.dart';
import 'package:nexo_finance/shared/models/transaction_model.dart';
import 'package:nexo_finance/shared/services/offline/account_service.dart';
import 'package:nexo_finance/shared/services/offline/transaction_service.dart';
import 'package:nexo_finance/shared/models/category_model.dart';
import 'package:nexo_finance/shared/services/offline/category_service.dart';
import '../../../shared/widgets/slide_card.dart';
import '../../../shared/widgets/transactions.dart';
import '../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/type_chip.dart';
import '../../../shared/widgets/banner_ad_widget.dart';
import '../../../shared/helpers/ad_helper.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  String _selectedFilter = 'Todas'; // Todas, Ingresos, Egresos
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() async {
    transactions = await TransactionService.getTransactions();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      filteredTransactions = transactions.where((t) {
        // Filter by Type
        bool matchesType = true;
        if (_selectedFilter == 'Ingresos') matchesType = !t.isExpense;
        if (_selectedFilter == 'Egresos') matchesType = t.isExpense;

        // Filter by Search Query
        bool matchesSearch = true;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          matchesSearch =
              t.title.toLowerCase().contains(query) ||
              t.category.toLowerCase().contains(query) ||
              t.account.toLowerCase().contains(query) ||
              (t.note?.toLowerCase().contains(query) ?? false);
        }

        return matchesType && matchesSearch;
      }).toList();
      // Sort by date descending
      filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => _TransactionDetailSheet(transaction: transaction),
    );
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
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          _searchQuery = value;
                          _applyFilters();
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Buscar transacciones...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    // Banner Ad 1
                    Center(
                      child: BannerAdWidget(
                        adUnitId: AdHelper.transactionsBanner1,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'Todas',
                            isSelected: _selectedFilter == 'Todas',
                            onTap: () {
                              setState(() => _selectedFilter = 'Todas');
                              _applyFilters();
                            },
                          ),
                          const SizedBox(width: 12),
                          _FilterChip(
                            label: 'Ingresos',
                            isSelected: _selectedFilter == 'Ingresos',
                            onTap: () {
                              setState(() => _selectedFilter = 'Ingresos');
                              _applyFilters();
                            },
                          ),
                          const SizedBox(width: 12),
                          _FilterChip(
                            label: 'Egresos',
                            isSelected: _selectedFilter == 'Egresos',
                            onTap: () {
                              setState(() => _selectedFilter = 'Egresos');
                              _applyFilters();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Transaction List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return Column(
                          children: [
                            SlideCard<Transaction>(
                              key: ValueKey(transaction.id),
                              item: transaction,
                              borderRadius: BorderRadius.circular(16),
                              rightOptions: [
                                SlideAction<Transaction>(
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  onPressed: (t) async {
                                    await TransactionService.delete(t.id);
                                    loadTransactions();
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Eliminado: ${t.title}',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                              child: GestureDetector(
                                onTap: () =>
                                    _showTransactionDetails(transaction),
                                child: TransactionCard(
                                  title: transaction.title,
                                  category: transaction.category,
                                  account: transaction.account,
                                  date: transaction.date.toString(),
                                  amount: transaction.amount.toString(),
                                  color: transaction.color,
                                  icon:
                                      transaction.icon ??
                                      (transaction.isExpense
                                          ? Icons.remove
                                          : Icons.add),
                                  isExpense: transaction.isExpense,
                                ),
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
            const SizedBox(height: 10),
            // Banner Ad 2
            Center(
              child: BannerAdWidget(adUnitId: AdHelper.transactionsBanner2),
            ),
            const SizedBox(height: 10),
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
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

class _TransactionDetailSheet extends StatelessWidget {
  final Transaction transaction;

  const _TransactionDetailSheet({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Detalle de Transacción',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.title, 'Título', transaction.title),
          _buildDetailRow(
            transaction.icon ?? Icons.category,
            'Categoría',
            transaction.category,
            iconColor: transaction.color,
          ),
          _buildDetailRow(
            Icons.account_balance_wallet,
            'Cuenta',
            transaction.account,
          ),
          _buildDetailRow(
            Icons.money,
            'Monto',
            '${transaction.isExpense ? "-" : "+"}\$ ${transaction.amount}',
            textColor: transaction.isExpense ? Colors.redAccent : Colors.green,
          ),
          if (transaction.conversionRate != 1.0)
            _buildDetailRow(
              Icons.currency_exchange,
              'Tasa de Conversión',
              '${transaction.conversionRate}',
            ),
          _buildDetailRow(
            Icons.calendar_today,
            'Fecha',
            DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
          ),
          if (transaction.note?.isNotEmpty ?? false)
            _buildDetailRow(Icons.note, 'Nota', transaction.note!),
          if (transaction.imagePath != null &&
              transaction.imagePath!.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Comprobante',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(transaction.imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
  File? _image;
  bool _isLoadingAI = false;

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _isLoadingAI = true;
      });

      try {
        final result = await IaService.processFile(_image!);
        setState(() {
          if (result.containsKey('amount')) {
            _amountController.text = result['amount'].toString();
          }
          if (result.containsKey('title')) {
            _titleController.text = result['title'].toString();
          }
          if (result.containsKey('concept')) {
            _noteController.text = result['concept'].toString();
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error procesando imagen: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoadingAI = false;
        });
      }
    }
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
            const SizedBox(height: 16),
            const Text(
              'Foto del Comprobante',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: _isLoadingAI
                    ? const Center(child: CircularProgressIndicator())
                    : _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Agregar Foto',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
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
                  imagePath: _image?.path,
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
