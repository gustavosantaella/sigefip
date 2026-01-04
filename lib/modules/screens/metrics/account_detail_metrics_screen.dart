import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexo_finance/l10n/generated/app_localizations.dart';
import 'package:nexo_finance/modules/screens/metrics/widgets/category_pie_chart.dart';
import 'package:nexo_finance/shared/models/account_model.dart';
import 'package:nexo_finance/shared/models/transaction_model.dart';
import 'package:nexo_finance/shared/widgets/custom_back_button.dart';

class AccountDetailMetricsScreen extends StatefulWidget {
  final Account account;
  final List<Transaction> transactions;
  final String periodLabel;

  const AccountDetailMetricsScreen({
    super.key,
    required this.account,
    required this.transactions,
    required this.periodLabel,
  });

  @override
  State<AccountDetailMetricsScreen> createState() =>
      _AccountDetailMetricsScreenState();
}

class _AccountDetailMetricsScreenState
    extends State<AccountDetailMetricsScreen> {
  // We'll filter transactions for this account in initState/build
  List<Transaction> get _accountTransactions => widget.transactions
      .where(
        (t) =>
            t.account.trim().toUpperCase() ==
            widget.account.name.trim().toUpperCase(),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    // Filter transactions for this specific account
    final transactions = _accountTransactions;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.account.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 56), // Align with title
                child: Text(
                  widget.periodLabel,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),

              // Account Header Card (similar to summary)
              _buildAccountHeader(transactions),
              const SizedBox(height: 40),

              // Timeline Chart
              Text(
                'Línea de Tiempo', // TODO: Localize
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: _buildTimelineChart(transactions),
              ),
              const SizedBox(height: 40),

              // Expenses Breakdown
              Text(
                AppLocalizations.of(context)!.expensesByCategory,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildCategoryChart(transactions, isExpense: true),
              const SizedBox(height: 40),

              // Income Breakdown
              Text(
                AppLocalizations.of(context)!.incomeByCategory,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildCategoryChart(transactions, isExpense: false),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountHeader(List<Transaction> transactions) {
    double income = 0;
    double expense = 0;

    for (var t in transactions) {
      // Amount is already raw, but we might want to respect the transaction currency vs account currency?
      // For now assume 1:1 since we are in the account detail and filtered by it.
      // Actually, metrics screen passed filters.
      // If conversion happens, it happens at service level usually or we just sum.
      // Let's sum raw amounts as they should be in the account's currency generally.
      if (t.isExpense) {
        expense += t.amount;
      } else {
        income += t.amount;
      }
    }

    final net = income - expense;
    final currency = widget.account.currency ?? 'USD';

    return Container(
      padding: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.account.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.account.icon,
                  color: widget.account.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.balance,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.simpleCurrency(name: currency).format(net),
                      style: TextStyle(
                        color: net >= 0 ? Colors.green : Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.incomeLabel,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(
                        name: currency,
                      ).format(income),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.expenseLabel,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      NumberFormat.simpleCurrency(
                        name: currency,
                      ).format(expense),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineChart(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Group by date
    // We need to know the range to fill gaps?
    // Or just plot points present. Line chart handles gaps by connecting lines usually.
    // Let's sort transactions by date.
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Aggregate by day
    final Map<int, Pair> dailyStats =
        {}; // key: day since epoch, value: (income, expense)

    for (var t in sorted) {
      final key = t.date.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24);
      dailyStats.putIfAbsent(key, () => Pair(0, 0));

      final current = dailyStats[key]!;
      if (t.isExpense) {
        dailyStats[key] = Pair(current.income, current.expense + t.amount);
      } else {
        dailyStats[key] = Pair(current.income + t.amount, current.expense);
      }
    }

    // Sort keys
    final days = dailyStats.keys.toList()..sort();

    if (days.isEmpty) return const SizedBox();

    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];

    // Normalize X to index 0..N for cleaner view?
    // Or use real timestamps? Real timestamps allows formatting date on X axis.

    for (int i = 0; i < days.length; i++) {
      final dayKey = days[i];
      final stat = dailyStats[dayKey]!;
      // X = index to keep equal spacing? Or distinct dates?
      // If we use index, we lose time gaps visually.
      // If we use date, gaps are visible. Let's use index for "Points in time" or date?
      // Standard is usually date.
      // Let's use index, but map index back to date for Tooltip/Axis (approx).
      incomeSpots.add(FlSpot(i.toDouble(), stat.income));
      expenseSpots.add(FlSpot(i.toDouble(), stat.expense));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1, // Auto?
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.white10, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1, // Show every point? Too crowded if many.
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= days.length) return const SizedBox();

                // Show label only for sparse points if many
                if (days.length > 7 && index % (days.length ~/ 5) != 0)
                  return const SizedBox();

                final date = DateTime.fromMillisecondsSinceEpoch(
                  days[index] * 24 * 60 * 60 * 1000,
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat(
                      'dd/MM',
                      AppLocalizations.of(context)!.localeName,
                    ).format(date),
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ), // Hide Y axis for cleaner look, tooltip is enough? Or minimal?
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Income Line
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
          // Expense Line
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.redAccent.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final index = flSpot.x.toInt();
                // We need to re-find the date from index
                // This is a bit fragile if multiple spots share X, but here X is index.
                String label;
                Color color;
                if (barSpot.barIndex == 0) {
                  // Income
                  label = "Inc";
                  color = Colors.green;
                } else {
                  label = "Exp";
                  color = Colors.redAccent;
                }

                if (index >= 0 && index < days.length) {
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    days[index] * 24 * 60 * 60 * 1000,
                  );
                  final dateStr = DateFormat('dd/MM').format(date);
                  // Show Date + Amount
                  return LineTooltipItem(
                    '$dateStr\n$label: \$${flSpot.y.toStringAsFixed(0)}',
                    TextStyle(color: color, fontWeight: FontWeight.bold),
                  );
                }

                return LineTooltipItem(
                  flSpot.y.toString(),
                  TextStyle(color: color),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChart(
    List<Transaction> transactions, {
    required bool isExpense,
  }) {
    final Map<String, CategoryChartData> stats = {};
    final currency = widget.account.currency ?? 'USD';

    for (var t in transactions.where((t) => t.isExpense == isExpense)) {
      final catName = t.category.trim();

      stats.update(
        catName,
        (val) => CategoryChartData(
          name: val.name,
          amount: val.amount + t.amount,
          color: val.color,
          currency: currency,
        ),
        ifAbsent: () => CategoryChartData(
          name: catName,
          amount: t.amount,
          color: t.color,
          currency: currency,
        ),
      );
    }

    if (stats.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final sortedStats = stats.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return CategoryPieChart(data: sortedStats, isExpense: isExpense);
  }
}

class Pair {
  final double income;
  final double expense;
  Pair(this.income, this.expense);
}
