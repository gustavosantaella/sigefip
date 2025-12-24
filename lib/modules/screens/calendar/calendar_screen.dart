import 'package:flutter/material.dart';
import 'package:sigefip/shared/models/transaction_model.dart';
import 'package:sigefip/shared/services/offline/transaction_service.dart';
import 'package:sigefip/shared/services/data_sync_notifier.dart';
import '../../../../shared/widgets/custom_back_button.dart';
import '../../../../shared/widgets/slide_card.dart';
import '../../../../shared/widgets/transactions.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    dataSyncNotifier.addListener(_loadTransactions);
  }

  @override
  void dispose() {
    dataSyncNotifier.removeListener(_loadTransactions);
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    final transactions = await TransactionService.getTransactions();
    if (mounted) {
      setState(() {
        _allTransactions = transactions;
        _isLoading = false;
      });
    }
  }

  List<Transaction> get _filteredTransactions {
    return _allTransactions.where((t) {
      return t.date.year == _selectedDate.year &&
          t.date.month == _selectedDate.month &&
          t.date.day == _selectedDate.day;
    }).toList();
  }

  double get _dayIncome => _filteredTransactions
      .where((t) => !t.isExpense)
      .fold(0, (sum, t) => sum + t.amount);

  double get _dayExpense => _filteredTransactions
      .where((t) => t.isExpense)
      .fold(0, (sum, t) => sum + t.amount);

  double get _monthIncome => _allTransactions
      .where((t) {
        return t.date.year == _selectedDate.year &&
            t.date.month == _selectedDate.month &&
            !t.isExpense;
      })
      .fold(0, (sum, t) => sum + t.amount);

  double get _monthExpense => _allTransactions
      .where((t) {
        return t.date.year == _selectedDate.year &&
            t.date.month == _selectedDate.month &&
            t.isExpense;
      })
      .fold(0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 16),
                  const Text(
                    'Calendario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Monthly Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      label: 'Ingresos Mes',
                      amount: _monthIncome,
                      color: Colors.green,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      label: 'Gastos Mes',
                      amount: _monthExpense,
                      color: Colors.red,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Calendar View
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF6C63FF),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E1E1E),
                    onSurface: Colors.white,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  onDateChanged: (date) {
                    setState(() => _selectedDate = date);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Transactions for selected date
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 24,
                        right: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Día ${_selectedDate.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              _buildMiniStat(
                                amount: _dayIncome,
                                color: Colors.green,
                                icon: Icons.add,
                              ),
                              const SizedBox(width: 12),
                              _buildMiniStat(
                                amount: _dayExpense,
                                color: Colors.red,
                                icon: Icons.remove,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Mock Empty State or List
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredTransactions.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event_note,
                                    size: 48,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay transacciones',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: _filteredTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    _filteredTransactions[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SlideCard<Transaction>(
                                    key: ValueKey(transaction.id),
                                    item: transaction,
                                    borderRadius: BorderRadius.circular(16),
                                    rightOptions: [
                                      SlideAction<Transaction>(
                                        icon: Icons.delete,
                                        color: Colors.red,
                                        onPressed: (transaction) async {
                                          setState(() {
                                            _allTransactions.remove(
                                              transaction,
                                            );
                                          });
                                          await TransactionService.delete(
                                            transaction.id,
                                          );
                                          _loadTransactions();
                                        },
                                      ),
                                    ],
                                    child: TransactionCard(
                                      title: transaction.title,
                                      category: transaction.category,
                                      account: transaction.account,
                                      date: transaction.date.toString(),
                                      amount: transaction.amount.toString(),
                                      isExpense: transaction.isExpense,
                                      color: transaction.color,
                                      icon:
                                          transaction.icon ??
                                          (transaction.isExpense
                                              ? Icons.remove
                                              : Icons.add),
                                    ),
                                  ),
                                );
                              },
                            ),
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

  Widget _buildSummaryCard({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
