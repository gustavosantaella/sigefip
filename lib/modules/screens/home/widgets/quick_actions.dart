import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _QuickAction(
          icon: Icons.calendar_today_outlined,
          label: 'Calendario',
          onTap: () {
            Navigator.pushNamed(context, '/calendar');
          },
        ),
        const SizedBox(width: 24),
        _QuickAction(
          icon: Icons.local_offer_outlined,
          label: 'Categorias',
          onTap: () {
            Navigator.pushNamed(context, '/categories');
          },
        ),
        const SizedBox(width: 24),
        _QuickAction(
          icon: Icons.pie_chart_outline,
          label: 'Presupuesto',
          onTap: () {
            Navigator.pushNamed(context, '/budget');
          },
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
