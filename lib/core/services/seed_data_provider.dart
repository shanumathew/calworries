import 'package:calworries/features/meals/data/models/meal.dart';
import 'package:calworries/features/meals/data/models/ingredient.dart';
import 'package:calworries/features/shopping/data/models/grocery_item.dart';
import 'package:calworries/features/shopping/data/models/spending_record.dart';
import 'package:calworries/core/constants/enums.dart';
import 'package:calworries/core/services/hive_service.dart';

class SeedDataProvider {
  static Future<void> seedData() async {
    try {
      final mealBox = HiveService.getMealsBox();
      if (mealBox.isEmpty) {
        await _seedMeals();
      }

      final shoppingBox = HiveService.getGroceriesBox();
      if (shoppingBox.isEmpty) {
        await _seedGroceries();
      }

      final spendingBox = HiveService.getSpendingBox();
      if (spendingBox.isEmpty) {
        await _seedSpending();
      }
    } catch (e) {
      print('Error seeding data: $e');
    }
  }

  static Future<void> _seedMeals() async {
    final ingredients1 = [
      Ingredient(name: 'Chicken', quantity: 200, unit: 'g'),
      Ingredient(name: 'Rice', quantity: 150, unit: 'g'),
      Ingredient(name: 'Oil', quantity: 2, unit: 'tbsp'),
    ];

    final ingredients2 = [
      Ingredient(name: 'Bread', quantity: 2, unit: 'slices'),
      Ingredient(name: 'Eggs', quantity: 2, unit: 'pieces'),
      Ingredient(name: 'Milk', quantity: 100, unit: 'ml'),
    ];

    final ingredients3 = [
      Ingredient(name: 'Fish', quantity: 150, unit: 'g'),
      Ingredient(name: 'Vegetables', quantity: 300, unit: 'g'),
      Ingredient(name: 'Oil', quantity: 1, unit: 'tbsp'),
    ];

    final meals = [
      Meal(
        name: 'Grilled Chicken with Rice',
        calories: 550,
        mealCategory: MealCategory.lunch.index,
        ingredients: ingredients1,
        healthRating: HealthRating.excellent.index,
        notes: 'Healthy lunch',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Meal(
        name: 'Breakfast Sandwich',
        calories: 350,
        mealCategory: MealCategory.breakfast.index,
        ingredients: ingredients2,
        healthRating: HealthRating.good.index,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      Meal(
        name: 'Grilled Fish with Veggies',
        calories: 480,
        mealCategory: MealCategory.dinner.index,
        ingredients: ingredients3,
        healthRating: HealthRating.excellent.index,
        notes: 'Light dinner',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];

    final box = HiveService.getMealsBox();
    for (final meal in meals) {
      await box.put(meal.id, meal);
    }
  }

  static Future<void> _seedGroceries() async {
    final groceries = [
      GroceryItem(
        name: 'Chicken',
        quantity: 1,
        unit: 'kg',
        category: GroceryCategory.protein.index,
        estimatedDaysToEmpty: 2,
        usageFrequency: 5,
      ),
      GroceryItem(
        name: 'Rice',
        quantity: 5,
        unit: 'kg',
        category: GroceryCategory.carbs.index,
        estimatedDaysToEmpty: 15,
        usageFrequency: 4,
      ),
      GroceryItem(
        name: 'Eggs',
        quantity: 12,
        unit: 'pieces',
        category: GroceryCategory.protein.index,
        estimatedDaysToEmpty: 1,
        usageFrequency: 3,
      ),
      GroceryItem(
        name: 'Milk',
        quantity: 1,
        unit: 'litre',
        category: GroceryCategory.dairy.index,
        estimatedDaysToEmpty: 3,
        usageFrequency: 2,
      ),
      GroceryItem(
        name: 'Vegetables',
        quantity: 2,
        unit: 'kg',
        category: GroceryCategory.veggies.index,
        estimatedDaysToEmpty: 5,
        usageFrequency: 4,
      ),
    ];

    final box = HiveService.getGroceriesBox();
    for (final grocery in groceries) {
      await box.put(grocery.id, grocery);
    }
  }

  static Future<void> _seedSpending() async {
    final spending = [
      SpendingRecord(
        itemName: 'Chicken',
        quantity: 1,
        unit: 'kg',
        price: 250,
        category: GroceryCategory.protein.index,
        purchasedAt: DateTime.now().subtract(Duration(days: 7)),
      ),
      SpendingRecord(
        itemName: 'Rice',
        quantity: 5,
        unit: 'kg',
        price: 200,
        category: GroceryCategory.carbs.index,
        purchasedAt: DateTime.now().subtract(Duration(days: 15)),
      ),
      SpendingRecord(
        itemName: 'Vegetables Bundle',
        quantity: 1,
        unit: 'bundle',
        price: 150,
        category: GroceryCategory.veggies.index,
        purchasedAt: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];

    final box = HiveService.getSpendingBox();
    for (final record in spending) {
      await box.put(record.id, record);
    }
  }
}
