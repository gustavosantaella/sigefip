import 'package:flutter/material.dart';
import '../../../shared/widgets/nav_item.dart';
import '../../router/routes.dart';
import '../../../shared/services/voice_service.dart';
import '../../../shared/services/transaction_parser_service.dart';
import '../../../shared/services/offline/transaction_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final VoiceService _voiceService = VoiceService();
  bool _isListening = false;
  bool _isProcessing = false;
  String _recognizedText = "Escuchando...";

  Future<void> _startListening() async {
    final available = await _voiceService.init();
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "Escuchando...";
      });
      _voiceService.startListening((text) async {
        setState(() {
          _recognizedText = text;
          _isProcessing = true;
        });
        // Process the result after a short delay to let the user see what was recognized
        await Future.delayed(const Duration(milliseconds: 800));
        await _processVoiceTransaction(text);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reconocimiento de voz no disponible o sin permisos'),
        ),
      );
    }
  }

  Future<void> _processVoiceTransaction(String text) async {
    try {
      await _voiceService.speak("Vale, estoy procesando tu solicitud");

      final transaction = await TransactionParserService.parseVoiceText(text);
      if (transaction != null) {
        await TransactionService.store(transaction);
        if (mounted) {
          setState(() {
            _isListening = false;
            _isProcessing = false;
          });

          await _voiceService.speak(
            transaction.isExpense ? "Egreso agregado" : "Ingreso agregado",
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Transacción creada: ${transaction.isExpense ? "-" : "+"}${transaction.amount} en ${transaction.category}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _isListening = false;
            _isProcessing = false;
          });
          await _voiceService.speak("Lo siento sucedió un error");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No pude entender la transacción. Intenta decir: "Gaste 30 en comida"',
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error processing voice transaction: $e");
      if (mounted) {
        setState(() {
          _isListening = false;
          _isProcessing = false;
        });
        await _voiceService.speak("Lo siento sucedió un error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: MainRouter.routes.map((route) => route.screen).toList(),
            ),
            if (_isListening)
              Container(
                color: Colors.black87,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isProcessing
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : const Icon(Icons.mic, color: Colors.blue, size: 80),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _recognizedText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () => setState(() => _isListening = false),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _isListening ? null : _startListening,
              backgroundColor: const Color(0xFF6C63FF),
              child: const Icon(Icons.mic, color: Colors.white),
            )
          : null,
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
