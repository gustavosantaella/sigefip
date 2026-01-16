import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/models/budget_model.dart';
import '../../../../shared/services/offline/budget_service.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/type_chip.dart';

class AddEditBudgetScreen extends StatefulWidget {
  final Budget? budget;

  const AddEditBudgetScreen({super.key, this.budget});

  @override
  State<AddEditBudgetScreen> createState() => _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends State<AddEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  String? _selectedCategory;
  String _type = 'Egreso';
  String? _concurrency;
  int _cutoffDay = 1;
  Color _selectedColor = const Color(0xFF6C63FF);
  IconData _selectedIcon = Icons.attach_money;

  // Custom Interval
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _concurrencies = [
    'Diario',
    'Semanal',
    'Mensual',
    'Trimestral',
    'Semestral',
    'Anual',
    'Personalizado',
    'Único',
  ];

  // TODO: Load these from CategoryService
  final List<String> _categories = [
    'Alimentación',
    'Transporte',
    'Servicios',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Ahorros', // Typically 'Ingreso' or transfer, but useful
    'Salario', // Income
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.budget;
    _titleController = TextEditingController(text: b?.title ?? '');
    _amountController = TextEditingController(text: b?.amount.toString() ?? '');
    _noteController = TextEditingController(text: b?.note ?? '');
    _selectedCategory = b?.category;
    _type = b?.type ?? 'Egreso';
    _concurrency = b?.concurrency;
    _cutoffDay = b?.cutoffDay ?? 1;
    _selectedColor = b?.color ?? const Color(0xFF6C63FF);
    _selectedIcon = b?.icon ?? Icons.attach_money;
    _startDate = b?.startDate;
    _endDate = b?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.budget == null ? 'Nuevo Presupuesto' : 'Editar Presupuesto',
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selection
              Row(
                children: [
                  Expanded(
                    child: TypeChip(
                      label: 'Ingreso',
                      isSelected: _type == 'Ingreso',
                      color: Colors.green,
                      onTap: () => setState(() => _type = 'Ingreso'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TypeChip(
                      label: 'Egreso',
                      isSelected: _type == 'Egreso',
                      color: Colors.redAccent,
                      onTap: () => setState(() => _type = 'Egreso'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _titleController,
                label: 'Título',
                hintText: 'Ej: Presupuesto Mensual',
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _amountController,
                label: 'Monto Objetivo',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),

              CustomDropdown<String>(
                label: 'Categoría',
                value: _selectedCategory,
                items: _categories,
                itemLabelBuilder: (val) => val,
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: 16),

              CustomDropdown<String>(
                label: 'Frecuencia',
                value: _concurrency,
                items: _concurrencies,
                itemLabelBuilder: (val) => val,
                onChanged: (val) => setState(() => _concurrency = val),
              ),
              const SizedBox(height: 16),

              if (_concurrency == 'Mensual') ...[
                Text(
                  'Día de corte mensual: $_cutoffDay',
                  style: const TextStyle(color: Colors.white70),
                ),
                Slider(
                  value: _cutoffDay.toDouble(),
                  min: 1,
                  max: 31,
                  divisions: 30,
                  activeColor: const Color(0xFF6C63FF),
                  onChanged: (val) => setState(() => _cutoffDay = val.toInt()),
                ),
                const SizedBox(height: 16),
              ],

              if (_concurrency == 'Personalizado') ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => _startDate = picked);
                          }
                        },
                        child: Text(
                          _startDate == null
                              ? 'Desde'
                              : _startDate.toString().split(' ')[0],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setState(() => _endDate = picked);
                        },
                        child: Text(
                          _endDate == null
                              ? 'Hasta'
                              : _endDate.toString().split(' ')[0],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (_concurrency == 'Único') ...[
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _startDate = picked);
                    }
                  },
                  child: Text(
                    _startDate == null
                        ? 'Seleccionar Fecha de Ejecución'
                        : 'Fecha: ${_startDate.toString().split(' ')[0]}',
                  ),
                ),
                const SizedBox(height: 16),
              ],

              CustomTextField(
                controller: _noteController,
                label: 'Nota (Opcional)',
                maxLines: 2,
              ),
              const SizedBox(height: 30),

              CustomButton(text: 'Guardar', onPressed: _saveBudget),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveBudget() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategory == null ||
        _concurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa los campos requeridos'),
        ),
      );
      return;
    }

    if (_concurrency == 'Único' && _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha de ejecución'),
        ),
      );
      return;
    }

    final double amount = double.tryParse(_amountController.text) ?? 0.0;

    final newBudget = Budget(
      id: widget.budget?.id ?? const Uuid().v4(),
      title: _titleController.text,
      amount: amount,
      category: _selectedCategory!,
      type: _type,
      concurrency: _concurrency!,
      cutoffDay: _concurrency == 'Mensual' ? _cutoffDay : null,
      note: _noteController.text,
      icon: _selectedIcon,
      color: _selectedColor,
      startDate: _startDate,
      endDate: _endDate,
    );

    if (widget.budget == null) {
      await BudgetService.createBudget(newBudget);
    } else {
      await BudgetService.updateBudget(newBudget);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
