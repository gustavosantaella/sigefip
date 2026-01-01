import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/services/offline/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: '¡Bienvenido a Nexo Finance!',
      description:
          'Tu compañero ideal para el control total de tus finanzas personales.',
      icon: Icons.account_balance_wallet_rounded,
      tip: 'Pequeños ahorros hoy, grandes metas mañana.',
      color: const Color(0xFF6C63FF),
    ),
    OnboardingData(
      title: 'Transacciones Diarias',
      description:
          'Podrás registrar tus ingresos y egresos diarios de forma rápida en el módulo de transacciones.',
      icon: Icons.swap_horiz_rounded,
      tip: 'Mantén un registro constante para no perder ni un centavo.',
      color: Colors.greenAccent,
    ),
    OnboardingData(
      title: 'Gestiona tus Cuentas',
      description:
          'Crea múltiples cuentas para separar tus ahorros de tus gastos diarios o inversiones.',
      icon: Icons.account_balance_rounded,
      tip:
          'Tener cuentas separadas te ayuda a no gastar lo que tienes destinado al ahorro.',
      color: Colors.tealAccent,
    ),
    OnboardingData(
      title: 'Historial en el Calendario',
      description:
          '¿Te olvidaste cuándo hiciste un movimiento? No te preocupes, podrás ver todos tus movimientos en una fecha específica dentro del calendario.',
      icon: Icons.calendar_month_rounded,
      tip: 'La organización es la clave del éxito financiero.',
      color: Colors.orangeAccent,
    ),
    OnboardingData(
      title: 'Análisis y Métricas',
      description:
          'Visualiza el comportamiento de tu dinero con gráficos detallados por categorías y periodos.',
      icon: Icons.pie_chart_rounded,
      tip: 'Entiende en qué gastas para optimizar tus ahorros.',
      color: Colors.blueAccent,
    ),
    OnboardingData(
      title: 'Alcanza tus Objetivos',
      description:
          'Empieza a administrar tus finanzas para que alcances tus objetivos y vivas con tranquilidad.',
      icon: Icons.auto_graph_rounded,
      tip: '¡El mejor momento para empezar es ahora!',
      color: const Color(0xFF6C63FF),
    ),
  ];

  Future<void> _completeOnboarding() async {
    await StorageService.instance.write('onboarding_completed', 'true');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pages[_currentPage].color.withOpacity(0.15),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Saltar',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: page.color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                page.icon,
                                size: 100,
                                color: page.color,
                              ),
                            ),
                            const SizedBox(height: 50),
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: page.color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      page.tip,
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Section: Indicators and Buttons
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? _pages[_currentPage].color
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Action Button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage == _pages.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: _currentPage == _pages.length - 1
                                ? 30
                                : 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: _pages[_currentPage].color,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: _pages[_currentPage].color.withOpacity(
                                  0.4,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? 'Empezar'
                                    : '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (_currentPage == _pages.length - 1)
                                const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final String tip;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.tip,
    required this.color,
  });
}
