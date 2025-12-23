import 'package:flutter/material.dart';
import '../../../shared/models/budget_model.dart';
import '../../../shared/widgets/custom_back_button.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Budget> budgets = [
      AppColors_budget_mock.food,
      AppColors_budget_mock.transport,
      AppColors_budget_mock.utilities,
      AppColors_budget_mock.entertainment,
    ];

    double totalLimit = budgets.fold(0, (sum, item) => sum + item.limit);
    double totalSpent = budgets.fold(0, (sum, item) => sum + item.spent);
    double totalProgress = (totalSpent / totalLimit).clamp(0.0, 1.0);

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
                    'Presupuesto Mensual',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Summary Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Gasto Total vs Límite',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(totalProgress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: totalProgress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gastado: \$${totalSpent.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Límite: \$${totalLimit.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Budget List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: budgets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: budget.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                budget.icon,
                                color: budget.color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                budget.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '\$${budget.spent.toStringAsFixed(0)} / \$${budget.limit.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: budget.spent > budget.limit
                                    ? Colors.redAccent
                                    : Colors.grey[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: budget.progress,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation(
                              budget.spent > budget.limit
                                  ? Colors.redAccent
                                  : budget.color,
                            ),
                            minHeight: 6,
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
    );
  }
}

// Temporary Mock Data Helper
class AppColors_budget_mock {
  static const Budget food = Budget(
    id: '1',
    category: 'Alimentación',
    limit: 5000.00,
    spent: 3200.00,
    icon: Icons.restaurant,
    color: Color(0xFFFF5252),
  );

  static const Budget transport = Budget(
    id: '2',
    category: 'Transporte',
    limit: 2000.00,
    spent: 1800.00,
    icon: Icons.directions_bus,
    color: Color(0xFF448AFF),
  );

  static const Budget utilities = Budget(
    id: '3',
    category: 'Servicios',
    limit: 3000.00,
    spent: 1500.00,
    icon: Icons.bolt,
    color: Color(0xFFFFAB40),
  );

  static const Budget entertainment = Budget(
    id: '4',
    category: 'Entretenimiento',
    limit: 1500.00,
    spent: 2000.00, // Over budget example
    icon: Icons.movie,
    color: Color(0xFFE040FB),
  );
}
