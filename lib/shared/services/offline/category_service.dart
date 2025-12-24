import 'package:sigefip/shared/models/category_model.dart';
import 'package:sigefip/shared/services/storage_service.dart';
import 'package:sigefip/core/constants/categories.dart';
import 'package:flutter/material.dart';

class CategoryService {
  static final StorageService storageService = StorageService.instance;
  static const String _key = "categories";

  static Future<void> store(Category category) async {
    await storageService.pushToArray(_key, category.toMap());
  }

  static Future<List<Category>> getCategories() async {
    List<Category> categories = await storageService.getTypedArray<Category>(
      _key,
      (json) => Category.fromMap(json),
    );

    if (categories.isEmpty) {
      await _seedCategories();
      categories = await getCategories();
    }

    return categories;
  }

  static Future<void> _seedCategories() async {
    final List<Category> initialCategories = [];

    for (var cat in expensesCategories) {
      initialCategories.add(
        Category(
          id: cat['uuid'] as String,
          name: cat['name'] as String,
          icon: cat['icon'] as IconData,
          color: cat['color'] as Color,
          type: 'Egreso',
        ),
      );
    }

    for (var cat in incomeCategories) {
      initialCategories.add(
        Category(
          id: cat['uuid'] as String,
          name: cat['name'] as String,
          icon: cat['icon'] as IconData,
          color: cat['color'] as Color,
          type: 'Ingreso',
        ),
      );
    }

    for (var category in initialCategories) {
      await store(category);
    }
  }

  static Future<Category> getByName(String name) async {
    List<Category> categories = await getCategories();
    return categories.where((category) => category.name == name).first;
  }
}
