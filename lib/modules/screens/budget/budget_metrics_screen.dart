import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/models/budget_model.dart';
import '../../../../shared/services/offline/budget_service.dart';
import '../../../../shared/widgets/type_chip.dart';
import '../metrics/widgets/category_pie_chart.dart';
import 'package:intl/intl.dart';

class BudgetMetricsScreen extends StatefulWidget {
  const BudgetMetricsScreen({super.key});

  @override
  State<BudgetMetricsScreen> createState() => _BudgetMetricsScreenState();
}

class _BudgetMetricsScreenState extends State<BudgetMetricsScreen> {
  List<Budget> _budgets = [];
  bool _isLoading = true;
  String _selectedType = 'Egreso'; // 'Ingreso', 'Egreso'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final budgets = await BudgetService.getBudgets();
    if (mounted) {
      setState(() {
        _budgets = budgets;
        _isLoading = false;
      });
    }
  }

  List<Budget> get _filteredBudgets {
    return _budgets
        .where((b) => b.type == _selectedType && b.status == 'completed')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Type
          Row(
            children: [
              Expanded(
                child: TypeChip(
                  label: 'Egresos',
                  isSelected: _selectedType == 'Egreso',
                  color: Colors.redAccent,
                  onTap: () => setState(() => _selectedType = 'Egreso'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TypeChip(
                  label: 'Ingresos',
                  isSelected: _selectedType == 'Ingreso',
                  color: Colors.green,
                  onTap: () => setState(() => _selectedType = 'Ingreso'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          _buildOverallPerformance(),
          const SizedBox(height: 40),

          Text(
            'Desglose por Presupuesto ($_selectedType)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildCategoryDistribution(),
        ],
      ),
    );
  }

  Widget _buildOverallPerformance() {
    double totalBudgeted = 0;
    double totalSpent = 0;

    for (var b in _filteredBudgets) {
      totalBudgeted += b.amount;
      totalSpent +=
          b.amount; // All budgets here are completed, so spent = amount
    }

    if (totalBudgeted == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'No hay presupuestos ejecutados',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    double progress = (totalSpent / totalBudgeted).clamp(0.0, 1.0);
    bool isOverBudget = totalSpent > totalBudgeted;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            'Rendimiento Global',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            '${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: isOverBudget ? Colors.redAccent : Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${NumberFormat.compactCurrency(symbol: '\$').format(totalSpent)} / ${NumberFormat.compactCurrency(symbol: '\$').format(totalBudgeted)}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: totalSpent,
                    color: isOverBudget
                        ? Colors.redAccent
                        : const Color(0xFF6C63FF),
                    radius: 20,
                    showTitle: false,
                  ),
                  if (!isOverBudget)
                    PieChartSectionData(
                      value: totalBudgeted - totalSpent,
                      color: Colors.white10,
                      radius: 15,
                      showTitle: false,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    final data = _filteredBudgets.map((b) {
      return CategoryChartData(
        name: b.title,
        amount: b.executedAmount, // Use executedAmount (0 if postponed)
        color: b.color,
      );
    }).toList();

    // Sort by spent amount
    data.sort((a, b) => b.amount.compareTo(a.amount));

    if (data.isEmpty || data.every((d) => d.amount == 0)) {
      return const Center(
        child: Text(
          'Sin datos de ejecución',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return CategoryPieChart(data: data, isExpense: _selectedType == 'Egreso');
  }
}
