import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  Future<bool> init() async {
    if (_isAvailable) return true;

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

  bool get isListening => _speech.isListening;
}
