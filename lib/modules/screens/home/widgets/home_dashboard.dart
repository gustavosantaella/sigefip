import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/models/transaction_model.dart';
import 'package:nexo_finance/shared/services/offline/transaction_service.dart';
import 'package:nexo_finance/shared/notifiers/data_sync_notifier.dart';
import 'accounts_section.dart';
import '../../../../shared/widgets/transactions.dart';
import 'quick_actions.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  List<Transaction> _recentTransactions = [];
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
    // Sort by date descending
    transactions.sort((a, b) => b.date.compareTo(a.date));

    if (mounted) {
      setState(() {
        _recentTransactions = transactions.take(10).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Finanzas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Accounts Section
          const AccountsSection(),
          const SizedBox(height: 30),
          // Quick Actions
          const QuickActionsSection(),

          const SizedBox(height: 30),

          // Recent Transactions
          const Text(
            'Transacciones Recientes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_recentTransactions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No hay transacciones recientes',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            )
          else
            ..._recentTransactions.map(
              (transaction) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TransactionCard(
                  title: transaction.title,
                  category: transaction.category,
                  account: transaction.account,
                  date: transaction.date.toString(),
                  amount: transaction.amount.toString(),
                  color: transaction.color,
                  icon:
                      transaction.icon ??
                      (transaction.isExpense ? Icons.remove : Icons.add),
                  isExpense: transaction.isExpense,
                ),
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
