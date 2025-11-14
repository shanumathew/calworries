import 'package:flutter/material.dart';
import 'package:calworries/features/meals/data/models/meal.dart';
import 'package:calworries/features/meals/data/models/ingredient.dart';
import 'package:calworries/core/services/hive_service.dart';
import 'package:intl/intl.dart';

class MealProvider extends ChangeNotifier {
  List<Meal> _meals = [];
  List<Ingredient> _ingredients = [];

  List<Meal> get meals => _meals;
  List<Ingredient> get ingredients => _ingredients;

  MealProvider() {
    _loadMeals();
    _loadIngredients();
  }

  void _loadMeals() {
    try {
      final box = HiveService.getMealsBox();
      _meals = box.values.toList();
      _meals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      // Error loading meals
    }
  }

  void _loadIngredients() {
    try {
      final box = HiveService.getIngredientsBox();
      _ingredients = box.values.toList();
    } catch (e) {
      // Error loading ingredients
    }
  }

  Future<void> addMeal(Meal meal) async {
    try {
      final box = HiveService.getMealsBox();
      await box.put(meal.id, meal);

      for (final ingredient in meal.ingredients) {
        await addOrUpdateIngredient(
          ingredient.copyWith(usageCount: ingredient.usageCount + 1),
        );
      }

      _loadMeals();
      _loadIngredients();
      notifyListeners();
    } catch (e) {
      // Error adding meal
    }
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      final box = HiveService.getMealsBox();
      await box.delete(mealId);
      _loadMeals();
      notifyListeners();
    } catch (e) {
      // Error deleting meal
    }
  }

  Future<void> addOrUpdateIngredient(Ingredient ingredient) async {
    try {
      final box = HiveService.getIngredientsBox();
      await box.put(ingredient.id, ingredient);
      _loadIngredients();
      notifyListeners();
    } catch (e) {
      // Error adding ingredient
    }
  }

  List<Meal> getMealsByDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _meals.where((meal) {
      final mealDateStr = DateFormat('yyyy-MM-dd').format(meal.createdAt);
      return mealDateStr == dateStr;
    }).toList();
  }

  int getDailyCalories(DateTime date) {
    return getMealsByDate(date).fold(0, (sum, meal) => sum + meal.calories);
  }

  List<Meal> getWeeklyMeals() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    return _meals
        .where(
          (meal) =>
              meal.createdAt.isAfter(weekAgo) &&
              meal.createdAt.isBefore(now.add(Duration(days: 1))),
        )
        .toList();
  }

  int getWeeklyCalories() {
    return getWeeklyMeals().fold(0, (sum, meal) => sum + meal.calories);
  }

  Map<String, int> getMostUsedIngredients({int limit = 5}) {
    final map = <String, int>{};
    for (final ingredient in _ingredients) {
      map[ingredient.name] = ingredient.usageCount;
    }
    final sortedEntries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries.take(limit));
  }

  List<Ingredient> getRecentlyUsedIngredients({int limit = 10}) {
    final sorted = List<Ingredient>.from(_ingredients);
    sorted.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    return sorted.take(limit).toList();
  }
}
