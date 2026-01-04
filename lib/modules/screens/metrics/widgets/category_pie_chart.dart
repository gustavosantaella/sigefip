import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryChartData {
  final String name;
  final double amount;
  final Color color;
  final String? currency;

  CategoryChartData({
    required this.name,
    required this.amount,
    required this.color,
    this.currency,
  });
}

class CategoryPieChart extends StatefulWidget {
  final List<CategoryChartData> data;
  final bool isExpense;

  const CategoryPieChart({
    super.key,
    required this.data,
    required this.isExpense,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'Sin datos para mostrar',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: showingSections(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    final double totalAmount = widget.data.fold(
      0,
      (sum, item) => sum + item.amount,
    );

    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final category = widget.data[i];
      final percentage = (category.amount / totalAmount * 100).toStringAsFixed(
        1,
      );

      return PieChartSectionData(
        color: category.color,
        value: category.amount,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: category.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    });
  }

  Widget _buildLegend() {
    // Show top 5 or all if less than 8, otherwise truncate?
    // For now show all.
    return Column(
      children: widget.data.map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              Text(
                category.currency != null
                    ? NumberFormat.simpleCurrency(
                        name: category.currency,
                      ).format(category.amount)
                    : NumberFormat.currency(
                        symbol: r'$',
                        decimalDigits: 2,
                      ).format(category.amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
