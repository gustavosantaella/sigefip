import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigefip/shared/models/transaction_model.dart';
import 'package:sigefip/shared/services/offline/transaction_service.dart';
import '../../../shared/widgets/custom_back_button.dart';
import '../../../shared/widgets/type_chip.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await TransactionService.getTransactions();
    if (mounted) {
      setState(() {
        _allTransactions = transactions;
        _isLoading = false;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    final now = DateTime.now();
    setState(() {
      _filteredTransactions = _allTransactions.where((t) {
        if (_selectedPeriod == 'Semanal') {
          return t.date.isAfter(now.subtract(const Duration(days: 7)));
        } else if (_selectedPeriod == 'Mensual') {
          return t.date.month == now.month && t.date.year == now.year;
        } else if (_selectedPeriod == 'Anual') {
          return t.date.year == now.year;
        } else if (_selectedPeriod == 'Intervalo' && _customRange != null) {
          return t.date.isAfter(
                _customRange!.start.subtract(const Duration(seconds: 1)),
              ) &&
              t.date.isBefore(_customRange!.end.add(const Duration(days: 1)));
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
                    Row(
                      children: [
                        _buildFilterChip('Semanal'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Mensual'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Anual'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Intervalo'),
                      ],
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
    return Expanded(
      child: TypeChip(
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
      ),
    );
  }

  Widget _buildSummarySection() {
    double totalIncome = 0;
    double totalExpense = 0;

    for (var t in _filteredTransactions) {
      if (t.isExpense) {
        totalExpense += t.amount * t.conversionRate;
      } else {
        totalIncome += t.amount * t.conversionRate;
      }
    }

    return Column(
      children: [
        Row(
          children: [
            _buildSummaryCard(
              'Ingresos',
              totalIncome,
              Colors.green,
              Icons.arrow_upward,
            ),
            const SizedBox(width: 16),
            _buildSummaryCard(
              'Gastos',
              totalExpense,
              Colors.redAccent,
              Icons.arrow_downward,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          'Balance Neto',
          totalIncome - totalExpense,
          (totalIncome - totalExpense) >= 0
              ? Colors.blueAccent
              : Colors.orangeAccent,
          Icons.account_balance_wallet_outlined,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color,
    IconData icon, {
    bool isFullWidth = false,
  }) {
    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    NumberFormat.currency(symbol: r'$').format(amount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return isFullWidth ? content : Expanded(child: content);
  }

  Widget _buildCategoryChart({required bool isExpense}) {
    final Map<String, _CategoryStat> stats = {};

    for (var t in _filteredTransactions.where(
      (t) => t.isExpense == isExpense,
    )) {
      stats.update(
        t.category,
        (val) => val..amount += (t.amount * t.conversionRate),
        ifAbsent: () => _CategoryStat(
          name: t.category,
          amount: t.amount * t.conversionRate,
          color: t.color,
        ),
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

    final sortedStats = stats.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final maxAmount = sortedStats.first.amount;

    return Column(
      children: sortedStats.map((stat) {
        final progress = stat.amount / maxAmount;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stat.name,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    NumberFormat.currency(symbol: r'$').format(stat.amount),
                    style: TextStyle(
                      color: stat.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: stat.color,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: stat.color.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
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

class _CategoryStat {
  final String name;
  double amount;
  final Color color;

  _CategoryStat({
    required this.name,
    required this.amount,
    required this.color,
  });
}
