import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/models/category_model.dart';
import 'package:nexo_finance/shared/services/offline/category_service.dart';
import '../../../shared/notifiers/data_sync_notifier.dart';
import '../../../../shared/widgets/custom_back_button.dart';
import '../../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/type_chip.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    dataSyncNotifier.addListener(_loadCategories);
  }

  @override
  void dispose() {
    dataSyncNotifier.removeListener(_loadCategories);
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await CategoryService.getCategories();
    setState(() {
      categories = loadedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  return GestureDetector(
                    onLongPress: category.isDefault
                        ? null
                        : () => _confirmDelete(context, category),
                    child: Container(
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
                              color: category.color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
            builder: (context) =>
                AddCategoryForm(onCategoryAdded: _loadCategories),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return CustomBottomSheet(
          title: '¿Eliminar categoría?',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Está seguro de querer eliminar la categoría "${category.name}"?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'No',
                      backgroundColor: Colors.white10,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Sí',
                      backgroundColor: Colors.redAccent,
                      onPressed: () async {
                        await CategoryService.delete(category.id);
                        _loadCategories();
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Categoría eliminada'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddCategoryForm extends StatefulWidget {
  final VoidCallback onCategoryAdded;

  const AddCategoryForm({super.key, required this.onCategoryAdded});

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
    // Finance & Shopping
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.payments,
    Icons.shopping_cart,
    Icons.shopping_bag,
    Icons.receipt,
    Icons.credit_card,
    Icons.savings,
    Icons.monetization_on,
    Icons.attach_money,
    Icons.request_quote,
    Icons.loyalty,
    Icons.local_offer,
    Icons.store,

    // Food & Drink
    Icons.restaurant,
    Icons.local_pizza,
    Icons.lunch_dining,
    Icons.bakery_dining,
    Icons.coffee,
    Icons.local_bar,
    Icons.celebration,
    Icons.cake,
    Icons.icecream,

    // Transport & Travel
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_bike,
    Icons.train,
    Icons.flight,
    Icons.hotel,
    Icons.commute,
    Icons.local_gas_station,
    Icons.ev_station,
    Icons.map, Icons.explore,

    // Home & Life
    Icons.home, Icons.bolt, Icons.water_drop, Icons.lightbulb, Icons.wifi,
    Icons.pets,
    Icons.family_restroom,
    Icons.child_care,
    Icons.cleaning_services,
    Icons.local_laundry_service, Icons.checkroom, Icons.kitchen,

    // Health & Wellness
    Icons.medical_services,
    Icons.local_hospital,
    Icons.fitness_center,
    Icons.spa,
    Icons.psychology, Icons.healing, Icons.self_improvement,

    // Entertainment & Tech
    Icons.movie, Icons.music_note, Icons.games, Icons.videogame_asset,
    Icons.tv,
    Icons.headphones,
    Icons.camera_alt,
    Icons.smartphone,
    Icons.laptop,

    // Education & Work
    Icons.school, Icons.book, Icons.work, Icons.business_center, Icons.computer,
    Icons.edit, Icons.print, Icons.mail, Icons.inventory,

    // Others
    Icons.category,
    Icons.star,
    Icons.heart_broken,
    Icons.favorite,
    Icons.redeem,
    Icons.handshake, Icons.groups, Icons.person, Icons.shield, Icons.policy,
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
            height: 200, // Increased height for grid
            child: GridView.builder(
              itemCount: _availableIcons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
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
                      color: isSelected ? _selectedColor : Colors.grey[400],
                      size: 24,
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
            onPressed: () async {
              final newCategory = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                icon: _selectedIcon,
                color: _selectedColor,
                type: _categoryType,
              );

              await CategoryService.store(newCategory);
              widget.onCategoryAdded();
              if (mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
