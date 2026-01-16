import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/budget_model.dart';
import '../../../../shared/models/account_model.dart';
import '../../../../shared/models/transaction_model.dart';
import '../../../../shared/services/offline/budget_service.dart';
import '../../../../shared/services/offline/account_service.dart';
import '../../../../shared/services/offline/transaction_service.dart';
import '../../../../shared/widgets/type_chip.dart';
import 'add_edit_budget_screen.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  String _typeFilter = 'Egreso'; // Ingreso, Egreso
  List<Budget> _budgets = [];
  bool _isLoading = true;
  bool _isProcessing = false; // Prevent duplicate operations

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
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
        .where((b) => b.type == _typeFilter && b.status == 'active')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditBudgetScreen(),
            ),
          );
          if (result == true) _loadBudgets();
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TypeChip(
                    label: 'Egresos',
                    isSelected: _typeFilter == 'Egreso',
                    color: Colors.redAccent,
                    onTap: () => setState(() => _typeFilter = 'Egreso'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TypeChip(
                    label: 'Ingresos',
                    isSelected: _typeFilter == 'Ingreso',
                    color: Colors.green,
                    onTap: () => setState(() => _typeFilter = 'Ingreso'),
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _filteredBudgets.isEmpty
                ? Center(
                    child: Text(
                      'No hay presupuestos de $_typeFilter',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredBudgets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildBudgetCard(_filteredBudgets[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(Budget budget) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: budget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(budget.icon, color: budget.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      budget.concurrency +
                          (budget.cutoffDay != null
                              ? ' (Corte: ${budget.cutoffDay})'
                              : ''),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (val) {
                  if (val == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditBudgetScreen(budget: budget),
                      ),
                    ).then((_) => _loadBudgets());
                  } else if (val == 'delete') {
                    _deleteBudget(budget);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Amount Display (No Progress)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Text(
                NumberFormat.currency(symbol: '\$').format(budget.amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button: Execute
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showExecuteDialog(budget),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: Text(
                budget.type == 'Ingreso'
                    ? 'Registrar Ingreso'
                    : 'Registrar Gasto',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: budget.type == 'Ingreso'
                    ? Colors.green
                    : Colors.redAccent,
                side: BorderSide(
                  color: budget.type == 'Ingreso'
                      ? Colors.green
                      : Colors.redAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Action Button: Postpone
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _postponeBudget(budget),
              icon: const Icon(Icons.schedule, size: 18),
              label: const Text('Aplazar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _postponeBudget(Budget budget) async {
    if (_isProcessing) return; // Prevent duplicate calls

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Aplazar Presupuesto',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Deseas aplazar "${budget.title}"? Se marcará como completado sin crear transacción.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Aplazar',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);

      try {
        await BudgetService.completeAndCloneBudget(budget, executedAmount: 0.0);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Presupuesto aplazado')));
        }
        await _loadBudgets();
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
  }

  Future<void> _deleteBudget(Budget budget) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Presupuesto'),
        content: Text('¿Seguro que quieres eliminar "${budget.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await BudgetService.deleteBudget(budget.id);
      _loadBudgets();
    }
  }

  Future<void> _showExecuteDialog(Budget budget) async {
    final accounts = await AccountService.getAccounts();
    Account? selectedAccount;

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: Text(
                'Ejecutar: ${budget.title}',
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Esto creará una transacción de ${budget.type.toLowerCase()} por \$${budget.amount} en la categoría ${budget.category}.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Account>(
                    decoration: const InputDecoration(
                      labelText: 'Selecciona Cuenta',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6C63FF)),
                      ),
                    ),
                    dropdownColor: const Color(0xFF2C2C2C),
                    style: const TextStyle(color: Colors.white),
                    items: accounts.map((acc) {
                      return DropdownMenuItem(
                        value: acc,
                        child: Text(acc.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedAccount = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedAccount == null) return;

                    final transaction = Transaction(
                      title: 'Ejecución: ${budget.title}',
                      amount: budget.amount,
                      date: DateTime.now(),
                      category: budget.category,
                      account: selectedAccount!.name,
                      isExpense: budget.type == 'Egreso',
                      icon: budget.icon,
                      color: budget.color,
                      note: 'Ejecutado desde presupuesto',
                    );

                    await TransactionService.store(transaction);

                    if (budget.concurrency == 'Unico' ||
                        budget.concurrency == 'Único') {
                      await BudgetService.deleteBudget(budget.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ejecutado correctamente (Presupuesto único eliminado)',
                            ),
                          ),
                        );
                      }
                    } else {
                      await BudgetService.completeAndCloneBudget(
                        budget,
                        executedAmount: budget.amount,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ejecutado correctamente'),
                          ),
                        );
                      }
                    }

                    if (mounted) {
                      Navigator.pop(ctx);
                    }
                    _loadBudgets();
                  },
                  child: const Text(
                    'Ejecutar',
                    style: TextStyle(color: Color(0xFF6C63FF)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
