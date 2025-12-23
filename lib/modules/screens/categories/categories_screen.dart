import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_back_button.dart';
import '../../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/type_chip.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.restaurant,
        'color': const Color(0xFFFF5252),
        'name': 'Comida',
      },
      {
        'icon': Icons.directions_bus,
        'color': const Color(0xFF448AFF),
        'name': 'Transporte',
      },
      {
        'icon': Icons.shopping_bag,
        'color': const Color(0xFFE040FB),
        'name': 'Compras',
      },
      {
        'icon': Icons.bolt,
        'color': const Color(0xFFFFAB40),
        'name': 'Servicios',
      },
      {
        'icon': Icons.movie,
        'color': const Color(0xFF69F0AE),
        'name': 'Entretenimiento',
      },
      {
        'icon': Icons.medical_services,
        'color': const Color(0xFFEF5350),
        'name': 'Salud',
      },
      {
        'icon': Icons.school,
        'color': const Color(0xFF536DFE),
        'name': 'Educación',
      },
      {
        'icon': Icons.card_giftcard,
        'color': const Color(0xFFFF6E40),
        'name': 'Regalos',
      },
      {
        'icon': Icons.savings,
        'color': const Color(0xFF4DB6AC),
        'name': 'Ahorros',
      },
      {'icon': Icons.more_horiz, 'color': Colors.grey, 'name': 'Otros'},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 16),
                  const Text(
                    'Categorías',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withOpacity(
                              0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => const AddCategoryForm(),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _nameController = TextEditingController();
  Color _selectedColor = const Color(0xFF6C63FF);
  IconData _selectedIcon = Icons.category;
  String _categoryType = 'Egreso';

  final List<Color> _availableColors = [
    const Color(0xFF6C63FF),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFF9800),
    const Color(0xFFF44336),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF00BCD4),
    const Color(0xFF8BC34A),
    const Color(0xFFFFEB3B),
  ];

  final List<IconData> _availableIcons = [
    Icons.restaurant,
    Icons.directions_bus,
    Icons.shopping_bag,
    Icons.bolt,
    Icons.movie,
    Icons.medical_services,
    Icons.school,
    Icons.card_giftcard,
    Icons.savings,
    Icons.home,
    Icons.directions_car,
    Icons.flight,
    Icons.fitness_center,
    Icons.pets,
    Icons.work,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Nueva Categoría',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Type Selection
          Row(
            children: [
              Expanded(
                child: TypeChip(
                  label: 'Ingreso',
                  isSelected: _categoryType == 'Ingreso',
                  color: Colors.green,
                  onTap: () => setState(() => _categoryType = 'Ingreso'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TypeChip(
                  label: 'Egreso',
                  isSelected: _categoryType == 'Egreso',
                  color: Colors.redAccent,
                  onTap: () => setState(() => _categoryType = 'Egreso'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _nameController,
            label: 'Nombre de la categoría',
            hintText: 'Ej. Comida, Alquiler...',
          ),
          const SizedBox(height: 20),

          const Text(
            'Icono',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableIcons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _selectedColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: _selectedColor, width: 2)
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? _selectedColor : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Color',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final color = _availableColors[index];
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),

          CustomButton(
            text: 'Guardar Categoría',
            onPressed: () {
              // Logic to save
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
