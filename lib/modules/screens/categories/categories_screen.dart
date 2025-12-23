import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_back_button.dart';

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
        onPressed: () {},
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
