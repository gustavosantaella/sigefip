import 'dart:convert';

import 'package:nexo_finance/shared/services/offline/user_service.dart';
import 'package:nexo_finance/shared/services/online/api_service.dart';

class AuthService {
  static Future<void> login(String email, String password) async {
    Map<String, String> d = {"email": email, "pwd": password};
    String b = base64Encode(utf8.encode(jsonEncode(d)));

    var r = await ApiService.instance.post(
      '/auth/login',
      {},
      headers: {'Authorization': 'Basic $b'},
    );

    await UserService.setToken(r['data']);
  }

  static Future<void> register(
    String name,
    String email,
    String password,
    String country,
  ) async {
    Map<String, String> d = {
      "name": name,
      "email": email,
      "password": password,
      "country": country,
    };

    await ApiService.instance.post('/auth/register', d);
  }
}
