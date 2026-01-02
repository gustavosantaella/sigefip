import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/env/main.dart';

class IaService {
  static Future<HashMap<String, Object>> processFile(File file) async {
    final url = Uri.parse("$API_URL/gemini/generate");
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> data = jsonDecode(responseBody);
    return HashMap<String, Object>.from(data);
  }
}
