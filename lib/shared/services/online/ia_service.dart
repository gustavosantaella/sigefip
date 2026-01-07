import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cross_file/cross_file.dart';

import '../../../core/env/main.dart';

class IaService {
  static Future<HashMap<String, Object>> processFile(XFile file) async {
    final url = Uri.parse("$API_URL/gemini/generate");
    final request = http.MultipartRequest('POST', url);

    // On web, we might need to read bytes
    final bytes = await file.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: file.name),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> data = jsonDecode(responseBody);
    return HashMap<String, Object>.from(data);
  }
}
