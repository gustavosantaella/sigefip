import 'package:nexo_finance/shared/models/category_model.dart';
import 'package:nexo_finance/shared/services/offline/storage_service.dart';
import 'package:nexo_finance/core/constants/categories.dart';
import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/notifiers/data_sync_notifier.dart';

class CategoryService {
  static final StorageService storageService = StorageService.instance;
  static const String _key = "categories";

  static Future<void> store(Category category) async {
    await storageService.pushToArray(_key, category.toMap());
    dataSyncNotifier.notifyCategoryChange();
  }

  static Future<List<Category>> getCategories() async {
    final List<Category> allCategories = [];

    // 1. Add Default Categories from constants
    for (var cat in expensesCategories) {
      allCategories.add(
        Category(
          id: cat['uuid'] as String,
          name: cat['name'] as String,
          icon: cat['icon'] as IconData,
          color: cat['color'] as Color,
          type: 'Egreso',
          isDefault: true,
        ),
      );
    }

    for (var cat in incomeCategories) {
      allCategories.add(
        Category(
          id: cat['uuid'] as String,
          name: cat['name'] as String,
          icon: cat['icon'] as IconData,
          color: cat['color'] as Color,
          type: 'Ingreso',
          isDefault: true,
        ),
      );
    }

    // 2. Add Saved Categories from storage
    final List<Category> savedCategories = await storageService
        .getTypedArray<Category>(_key, (json) => Category.fromMap(json));

    allCategories.addAll(savedCategories);

    return allCategories;
  }

  static Future<Category?> getByName(String name) async {
    List<Category> categories = await getCategories();
    try {
      return categories.firstWhere((category) => category.name == name);
    } catch (e) {
      return null;
    }
  }

  static Future<void> delete(String id) async {
    // Prevent deletion if it's a default category (ID starts with 'df')
    if (id.startsWith('df')) {
      debugPrint('Cannot delete default category: $id');
      return;
    }
    await storageService.removeFromArray(_key, id);
    dataSyncNotifier.notifyCategoryChange();
  }
}
