import 'package:tareas/models/task.dart';
import 'package:flutter/material.dart';
import '../models/categories.dart';
import '../utils/database_helper.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  CategoriesProvider() {
    _fetchCategories();
    _loadData();
  }

  Future<void> _fetchCategories() async {
    _categories = await _dbHelper.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await _dbHelper.insertCategory(category);
    _fetchCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _dbHelper.updateCategory(category);
    _fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _dbHelper.deleteCategory(id);
    _fetchCategories();
  }

  Future<void> _loadData() async {
    _categories = await _dbHelper.getCategories();
    notifyListeners();
  }

  // Verificar si hay tareas asociados a una categoría
  Future<bool> hasTasksInCategory(int categoryId, List<Task> tasks) async {
    return tasks.any((task) => task.categoryId == categoryId);
  }
}
