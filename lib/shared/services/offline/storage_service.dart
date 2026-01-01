import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService._privateConstructor();

  static final StorageService _instance = StorageService._privateConstructor();

  static StorageService get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> pushToArray(String key, Map<String, dynamic> item) async {
    final List<dynamic> existingList = (await getArray(key)) ?? [];
    existingList.add(item);
    await write(key, json.encode(existingList));
  }

  Future<List<T>> getTypedArray<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final List<dynamic> list = (await getArray(key)) ?? [];
    return list
        .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<dynamic>?> getArray(String key) async {
    final String? value = await read(key);
    if (value == null) return null;
    if (value.isEmpty) return [];
    try {
      final decoded = json.decode(value);
      if (decoded is List) return decoded;
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> removeFromArray(String key, String id) async {
    final List<dynamic> existingList = (await getArray(key)) ?? [];
    existingList.removeWhere((item) => item['id'] == id);
    await write(key, json.encode(existingList));
  }
}
