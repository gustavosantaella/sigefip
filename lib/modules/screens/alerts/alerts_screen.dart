import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/alert_model.dart';
import '../../../shared/models/account_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/services/offline/alert_service.dart';
import '../../../shared/services/offline/account_service.dart';
import '../../../shared/services/offline/category_service.dart';
import '../../../shared/services/offline/transaction_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Alert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final alerts = await AlertService.getAlerts();
    if (mounted) {
      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    }
  }

  Future<double> _calculateSpentAmount(Alert alert) async {
    final transactions = await TransactionService.getTransactions();
    final now = DateTime.now();

    DateTime startDate;
    DateTime endDate = now;

    if (alert.period == 'Mensual') {
      int year = now.year;
      int month = now.month;

      if (now.day >= alert.cutoffDay) {
        startDate = DateTime(year, month, alert.cutoffDay);
      } else {
        month = month - 1;
        if (month == 0) {
          month = 12;
          year = year - 1;
        }
        startDate = DateTime(year, month, alert.cutoffDay);
      }
    } else {
      int year = now.year;
      int month = now.month;

      if (month > 1 || (month == 1 && now.day >= alert.cutoffDay)) {
        startDate = DateTime(year, 1, alert.cutoffDay);
      } else {
        startDate = DateTime(year - 1, 1, alert.cutoffDay);
      }
    }

    double total = 0;
    for (var transaction in transactions) {
      if (transaction.category == alert.category &&
          transaction.account == alert.account &&
          transaction.isExpense &&
          transaction.date.isAfter(startDate) &&
          transaction.date.isBefore(endDate.add(const Duration(days: 1)))) {
        total += transaction.amount;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Alertas de Gasto',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _alerts.isEmpty
          ? const Center(
              child: Text(
                'No hay alertas configuradas',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildAlertCard(_alerts[index]);
              },
            ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return FutureBuilder<double>(
      future: _calculateSpentAmount(alert),
      builder: (context, snapshot) {
        final spent = snapshot.data ?? 0.0;
        final progress = (spent / alert.maxAmount).clamp(0.0, 1.0);
        final isOverBudget = spent > alert.maxAmount;
        final percentage = (progress * 100).toStringAsFixed(1);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isOverBudget
                ? Colors.red.shade900.withOpacity(0.3)
                : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isOverBudget ? Colors.red : Colors.white10,
              width: isOverBudget ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: alert.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(alert.icon, color: alert.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${alert.account} • ${alert.period} • Corte: ${alert.cutoffDay}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (val) {
                      if (val == 'edit') {
                        _showAddEditDialog(alert: alert);
                      } else if (val == 'delete') {
                        _deleteAlert(alert);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverBudget ? Colors.red : alert.color,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Amount Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isOverBudget
                        ? '-${NumberFormat.currency(symbol: '\$').format(spent - alert.maxAmount)}'
                        : NumberFormat.currency(symbol: '\$').format(spent),
                    style: TextStyle(
                      color: isOverBudget ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$percentage% de ${NumberFormat.currency(symbol: '\$').format(alert.maxAmount)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteAlert(Alert alert) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Eliminar Alerta',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Seguro que quieres eliminar la alerta de "${alert.category}"?',
          style: const TextStyle(color: Colors.white70),
        ),
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
      await AlertService.deleteAlert(alert.id);
      _loadAlerts();
    }
  }

  Future<void> _showAddEditDialog({Alert? alert}) async {
    final categories = await CategoryService.getCategories();
    final expenseCategories = categories
        .where((c) => c.type == 'Egreso')
        .toList();
    final accounts = await AccountService.getAccounts();

    Category? selectedCategory;
    Account? selectedAccount;

    if (alert != null) {
      selectedCategory = expenseCategories.firstWhere(
        (c) => c.name == alert.category,
        orElse: () => expenseCategories.first,
      );
      selectedAccount = accounts.firstWhere(
        (a) => a.name == alert.account,
        orElse: () => accounts.first,
      );
    }

    final amountController = TextEditingController(
      text: alert?.maxAmount.toString() ?? '',
    );
    final cutoffDayController = TextEditingController(
      text: alert?.cutoffDay.toString() ?? '1',
    );
    String selectedPeriod = alert?.period ?? 'Mensual';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert == null ? 'Nueva Alerta' : 'Editar Alerta',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Dropdown
                    DropdownButtonFormField<Category>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
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
                      items: expenseCategories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(cat.icon, color: cat.color, size: 20),
                              const SizedBox(width: 8),
                              Text(cat.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setModalState(() => selectedCategory = val),
                    ),
                    const SizedBox(height: 16),

                    // Account Dropdown
                    DropdownButtonFormField<Account>(
                      value: selectedAccount,
                      decoration: const InputDecoration(
                        labelText: 'Cuenta',
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
                          child: Row(
                            children: [
                              Icon(acc.icon, color: acc.color, size: 20),
                              const SizedBox(width: 8),
                              Text(acc.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setModalState(() => selectedAccount = val),
                    ),
                    const SizedBox(height: 16),

                    // Max Amount
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Monto Máximo',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Period
                    DropdownButtonFormField<String>(
                      value: selectedPeriod,
                      decoration: const InputDecoration(
                        labelText: 'Período',
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
                      items: ['Mensual', 'Anual'].map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setModalState(() => selectedPeriod = val!),
                    ),
                    const SizedBox(height: 16),

                    // Cutoff Day TextField
                    TextField(
                      controller: cutoffDayController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Día de Corte (1-31)',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedCategory == null ||
                              selectedAccount == null ||
                              amountController.text.isEmpty ||
                              cutoffDayController.text.isEmpty) {
                            return;
                          }

                          final cutoffDay =
                              int.tryParse(cutoffDayController.text) ?? 1;
                          if (cutoffDay < 1 || cutoffDay > 31) {
                            return;
                          }

                          final newAlert = Alert(
                            id: alert?.id ?? const Uuid().v4(),
                            category: selectedCategory!.name,
                            account: selectedAccount!.name,
                            maxAmount: double.parse(amountController.text),
                            period: selectedPeriod,
                            cutoffDay: cutoffDay,
                            icon: selectedCategory!.icon,
                            color: selectedCategory!.color,
                          );

                          if (alert == null) {
                            await AlertService.createAlert(newAlert);
                          } else {
                            await AlertService.updateAlert(newAlert);
                          }

                          if (mounted) {
                            Navigator.pop(ctx);
                          }
                          _loadAlerts();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          alert == null ? 'Crear Alerta' : 'Guardar Cambios',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
