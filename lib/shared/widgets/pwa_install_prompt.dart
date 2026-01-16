import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PwaInstallPrompt extends StatelessWidget {
  const PwaInstallPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_to_home_screen_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Instalar Aplicación',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Para una mejor experiencia, agrega la aplicación a tu pantalla de inicio:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildInstructionStep(
              context,
              1,
              isIos ? 'Toca el botón compartir' : 'Toca el menú del navegador',
              isIos ? Icons.ios_share : Icons.more_vert,
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              context,
              2,
              isIos
                  ? 'Selecciona "Agregar a Inicio"'
                  : 'Selecciona "Instalar aplicación" o "Agregar a pantalla principal"',
              Icons.add_box_outlined,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Entendido'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
    BuildContext context,
    int number,
    String text,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: Colors.grey[600], size: 24),
      ],
    );
  }
}
