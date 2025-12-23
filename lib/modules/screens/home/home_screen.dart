import 'package:flutter/material.dart';
import '../../../shared/widgets/nav_item.dart';
import '../../router/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: MainRouter.routes.map((route) => route.screen).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Color(0xFF1E1E1E),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: MainRouter.routes.asMap().entries.map((entry) {
            final int idx = entry.key;
            final AppRoute route = entry.value;
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = idx),
              child: NavItem(
                icon: route.icon,
                label: route.title,
                isSelected: _currentIndex == idx,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
