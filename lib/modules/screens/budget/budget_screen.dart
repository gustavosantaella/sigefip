import 'package:flutter/material.dart';
import '../../../shared/models/budget_model.dart';
import '../../../shared/widgets/custom_back_button.dart';
import '../../../../core/constants/currencies.dart';
import '../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/type_chip.dart';
import '../../../shared/widgets/custom_date_picker.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  String _selectedFilter = 'Todos';

  final List<String> _filters = [
    'Todos',
    'Diario',
    'Semanal',
    'Mensual',
    'Trimestral',
    'Semestral',
    'Anual',
    'Eventualmente',
    'Personalizado',
  ];

  // Mock Data
  final List<Budget> _allBudgets = [
    AppColors_budget_mock.food,
    AppColors_budget_mock.transport,
    AppColors_budget_mock.utilities,
    AppColors_budget_mock.entertainment,
  ];

  List<Budget> get _filteredBudgets {
    if (_selectedFilter == 'Todos') {
      return _allBudgets;
    }
    return _allBudgets
        .where((budget) => budget.concurrency == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double totalLimit = _filteredBudgets.fold(
      0,
      (sum, item) => sum + item.limit,
    );
    double totalSpent = _filteredBudgets.fold(
      0,
      (sum, item) => sum + item.spent,
    );
    // Avoid division by zero
    double totalProgress = totalLimit > 0
        ? (totalSpent / totalLimit).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => const AddBudgetForm(),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 16),
                  const Text(
                    'Presupuesto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                    backgroundColor: const Color(0xFF1E1E1E),
                    selectedColor: const Color(0xFF6C63FF),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : Colors.white10,
                      ),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

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
              child: _filteredBudgets.isEmpty
                  ? Center(
                      child: Text(
                        'No hay presupuestos para este filtro',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _filteredBudgets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final budget = _filteredBudgets[index];
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          budget.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          budget.concurrency,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
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

class AddBudgetForm extends StatefulWidget {
  const AddBudgetForm({super.key});

  @override
  State<AddBudgetForm> createState() => _AddBudgetFormState();
}

class _AddBudgetFormState extends State<AddBudgetForm> {
  String? _selectedCategory;
  String? _selectedCurrency;
  String? _selectedConcurrency;
  String _budgetType = 'Egreso'; // 'Ingreso' or 'Egreso'
  final TextEditingController _limitController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _concurrencies = [
    'Diario',
    'Semanal',
    'Mensual',
    'Trimestral',
    'Semestral',
    'Anual',
    'Eventualmente',
    'Personalizado',
  ];

  // Mock Categories for Dropdown
  final List<String> _categories = [
    'Alimentación',
    'Transporte',
    'Servicios',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Ahorros',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Nuevo Presupuesto',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Budget Type Selection
          Row(
            children: [
              Expanded(
                child: TypeChip(
                  label: 'Ingreso',
                  isSelected: _budgetType == 'Ingreso',
                  color: Colors.green,
                  onTap: () => setState(() => _budgetType = 'Ingreso'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TypeChip(
                  label: 'Egreso',
                  isSelected: _budgetType == 'Egreso',
                  color: Colors.redAccent,
                  onTap: () => setState(() => _budgetType = 'Egreso'),
                ),
              ),
            ],
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

          // Currency Dropdown
          CustomDropdown<String>(
            label: 'Moneda',
            value: _selectedCurrency,
            items: currencies, // From core constants
            itemLabelBuilder: (item) => item,
            onChanged: (val) => setState(() => _selectedCurrency = val),
          ),
          const SizedBox(height: 16),

          // Limit Input
          CustomTextField(
            controller: _limitController,
            label: 'Monto Límite',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Concurrency Dropdown
          CustomDropdown<String>(
            label: 'Concurrencia',
            value: _selectedConcurrency,
            items: _concurrencies,
            itemLabelBuilder: (item) => item,
            onChanged: (val) => setState(() => _selectedConcurrency = val),
          ),

          if (_selectedConcurrency == 'Personalizado') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomDatePicker(
                    label: 'Desde',
                    selectedDate: _startDate,
                    onDateSelected: (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDatePicker(
                    label: 'Hasta',
                    selectedDate: _endDate,
                    onDateSelected: (date) => setState(() => _endDate = date),
                    firstDate: _startDate,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 30),

          // Save Button
          CustomButton(
            text: 'Guardar Presupuesto',
            onPressed: () {
              // Logic to save budget would go here
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 30),
        ],
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
    concurrency: 'Mensual',
  );

  static const Budget transport = Budget(
    id: '2',
    category: 'Transporte',
    limit: 2000.00,
    spent: 1800.00,
    icon: Icons.directions_bus,
    color: Color(0xFF448AFF),
    concurrency: 'Semanal',
  );

  static const Budget utilities = Budget(
    id: '3',
    category: 'Servicios',
    limit: 3000.00,
    spent: 1500.00,
    icon: Icons.bolt,
    color: Color(0xFFFFAB40),
    concurrency: 'Mensual',
  );

  static const Budget entertainment = Budget(
    id: '4',
    category: 'Entretenimiento',
    limit: 1500.00,
    spent: 2000.00, // Over budget example
    icon: Icons.movie,
    color: Color(0xFFE040FB),
    concurrency: 'Eventualmente',
  );
}
