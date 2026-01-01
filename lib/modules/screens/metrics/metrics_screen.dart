import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexo_finance/shared/models/transaction_model.dart';
import 'package:nexo_finance/shared/services/offline/transaction_service.dart';
import 'package:nexo_finance/shared/services/offline/account_service.dart';
import 'package:nexo_finance/shared/models/account_model.dart';
import '../../../shared/widgets/custom_back_button.dart';
import '../../../shared/widgets/type_chip.dart';
import 'widgets/category_pie_chart.dart';

class MetricsScreen extends StatefulWidget {
  const MetricsScreen({super.key});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  String _selectedPeriod = 'Mensual'; // Semanal, Mensual, Anual, Intervalo
  DateTimeRange? _customRange;
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  List<Account> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await TransactionService.getTransactions();
    final accounts = await AccountService.getAccounts();
    if (mounted) {
      setState(() {
        _allTransactions = transactions;
        _accounts = accounts;
        _isLoading = false;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _filteredTransactions = _allTransactions.where((t) {
        final tDate = DateTime(t.date.year, t.date.month, t.date.day);
        if (_selectedPeriod == 'Semanal') {
          final weekAgo = today.subtract(const Duration(days: 7));
          return tDate.isAfter(weekAgo.subtract(const Duration(seconds: 1)));
        } else if (_selectedPeriod == 'Mensual') {
          return t.date.month == now.month && t.date.year == now.year;
        } else if (_selectedPeriod == "Diario") {
          return tDate.isAtSameMomentAs(today);
        } else if (_selectedPeriod == 'Anual') {
          return t.date.year == now.year;
        } else if (_selectedPeriod == 'Intervalo' && _customRange != null) {
          final start = DateTime(
            _customRange!.start.year,
            _customRange!.start.month,
            _customRange!.start.day,
          );
          final end = DateTime(
            _customRange!.end.year,
            _customRange!.end.month,
            _customRange!.end.day,
          );
          return tDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
              tDate.isBefore(end.add(const Duration(days: 1)));
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CustomBackButton(),
                        const SizedBox(width: 16),
                        const Text(
                          'Métricas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Diario'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Semanal'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Mensual'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Anual'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Intervalo'),
                        ],
                      ),
                    ),
                    if (_selectedPeriod == 'Intervalo' &&
                        _customRange != null) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          '${DateFormat('dd/MM/yyyy').format(_customRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_customRange!.end)}',
                          style: const TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),

                    _buildSummarySection(),
                    const SizedBox(height: 40),

                    const Text(
                      'Gastos por Categoría',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCategoryChart(isExpense: true),

                    const SizedBox(height: 40),
                    const Text(
                      'Ingresos por Categoría',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCategoryChart(isExpense: false),
                    const SizedBox(height: 40),
                    _buildAccountUsageSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedPeriod == label;
    return TypeChip(
      label: label,
      isSelected: isSelected,
      color: const Color(0xFF6C63FF),
      onTap: () async {
        if (label == 'Intervalo') {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            initialDateRange: _customRange,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF6C63FF),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E1E1E),
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            setState(() {
              _selectedPeriod = label;
              _customRange = picked;
              _applyFilter();
            });
          }
        } else {
          setState(() {
            _selectedPeriod = label;
            _applyFilter();
          });
        }
      },
    );
  }

  Widget _buildSummarySection() {
    final Map<String, Map<String, double>> accountStats = {};

    for (var t in _filteredTransactions) {
      final accountKey = t.account.trim().toUpperCase();
      accountStats.putIfAbsent(accountKey, () => {'income': 0, 'expense': 0});
      final rate = t.conversionRate > 0 ? t.conversionRate : 1.0;
      final amount = t.amount * rate;
      if (t.isExpense) {
        accountStats[accountKey]!['expense'] =
            accountStats[accountKey]!['expense']! + amount;
      } else {
        accountStats[accountKey]!['income'] =
            accountStats[accountKey]!['income']! + amount;
      }
    }

    if (accountStats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'No hay transacciones en este periodo',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen por Cuenta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ..._accounts.map((account) {
          final stats =
              accountStats[account.name.trim().toUpperCase()] ??
              {'income': 0, 'expense': 0};
          final netBalance = stats['income']! - stats['expense']!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: account.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          account.icon,
                          color: account.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        account.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        NumberFormat.currency(symbol: r'$').format(netBalance),
                        style: TextStyle(
                          color: netBalance >= 0 ? Colors.green : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 24),
                  Row(
                    children: [
                      _buildMiniStat(
                        'Ingresos',
                        stats['income']!,
                        Colors.green,
                      ),
                      const SizedBox(width: 16),
                      _buildMiniStat(
                        'Egresos',
                        stats['expense']!,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMiniStat(String label, double amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            NumberFormat.currency(symbol: r'$').format(amount),
            style: TextStyle(
              color: color.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart({required bool isExpense}) {
    // 1. Group transactions by category
    final Map<String, CategoryChartData> stats = {};

    for (var t in _filteredTransactions.where(
      (t) => t.isExpense == isExpense,
    )) {
      final rate = t.conversionRate > 0 ? t.conversionRate : 1.0;
      final amount = t.amount * rate;

      // Handle the case where category might not be standardized
      final catName = t.category.trim();

      stats.update(
        catName,
        (val) => CategoryChartData(
          name: val.name,
          amount: val.amount + amount,
          color: val.color,
        ), // Keep existing color
        ifAbsent: () =>
            CategoryChartData(name: catName, amount: amount, color: t.color),
      );
    }

    if (stats.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'Sin datos para mostrar',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // 2. Convert to list and sort by amount descending
    final sortedStats = stats.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return CategoryPieChart(data: sortedStats, isExpense: isExpense);
  }

  Widget _buildAccountUsageSection() {
    final Map<String, int> accountHits = {};
    for (var t in _filteredTransactions) {
      accountHits.update(t.account, (val) => val + 1, ifAbsent: () => 1);
    }

    if (accountHits.isEmpty) return const SizedBox.shrink();

    final sortedAccounts = accountHits.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final mostUsed = sortedAccounts.first;
    final leastUsed = sortedAccounts.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uso de Cuentas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildInfoCard(
              'Más Usada',
              mostUsed.key,
              '${mostUsed.value} trans.',
              const Color(0xFF6C63FF),
              Icons.star_outline,
            ),
            const SizedBox(width: 16),
            _buildInfoCard(
              'Menos Usada',
              leastUsed.key,
              '${leastUsed.value} trans.',
              Colors.orangeAccent,
              Icons.trending_down,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String account,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              account,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
