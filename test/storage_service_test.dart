import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigefip/shared/services/offline/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('should write and read a value', () async {
      final storage = StorageService.instance;
      const key = 'test_key';
      const value = 'test_value';

      await storage.write(key, value);
      final result = await storage.read(key);

      expect(result, value);
    });

    test('should delete a value', () async {
      final storage = StorageService.instance;
      const key = 'test_key';
      const value = 'test_value';

      await storage.write(key, value);
      await storage.delete(key);
      final result = await storage.read(key);

      expect(result, null);
    });

    test('should delete all values', () async {
      final storage = StorageService.instance;
      await storage.write('key1', 'value1');
      await storage.write('key2', 'value2');

      await storage.deleteAll();

      expect(await storage.read('key1'), null);
      expect(await storage.read('key2'), null);
    });
  });
}
