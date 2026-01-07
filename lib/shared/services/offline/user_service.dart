import 'dart:convert';
import '../../models/user_model.dart';
import 'storage_service.dart';

class UserService {
  static const String _userKey = 'user_data';

  static Future<User?> getUser() async {
    final String? userData = await StorageService.instance.read(_userKey);
    if (userData == null || userData.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> json = jsonDecode(userData);
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUser(User user) async {
    final String userData = jsonEncode(user.toJson());
    await StorageService.instance.write(_userKey, userData);
  }

  static Future<void> updateUser({
    String? name,
    String? email,
    String? imagePath,
  }) async {
    final User? currentUser = await getUser();
    final User updatedUser = User(
      name: name ?? currentUser?.name,
      email: email ?? currentUser?.email,
      imagePath: imagePath ?? currentUser?.imagePath,
    );
    await saveUser(updatedUser);
  }

  static Future<void> clearUser() async {
    await StorageService.instance.delete(_userKey);
  }
}
