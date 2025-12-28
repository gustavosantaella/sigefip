import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isAvailable = false;

  Future<bool> init() async {
    if (_isAvailable) return true;

    // Initialize TTS
    try {
      await _tts.setLanguage("es-ES");
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.5);
    } catch (e) {
      debugPrint("Error initializing TTS: $e");
      // Fallback or continue as voice recognition might still work
    }

    // Check and request microphone permission
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    _isAvailable = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    return _isAvailable;
  }

  void startListening(Function(String) onResult) {
    if (!_isAvailable) return;

    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'es-ES', // Default to Spanish as requested
      listenMode: ListenMode.confirmation,
    );
  }

  void stopListening() {
    _speech.stop();
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  bool get isListening => _speech.isListening;
}
