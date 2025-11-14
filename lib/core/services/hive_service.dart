import 'package:hive_flutter/hive_flutter.dart';
import 'package:calworries/features/meals/data/models/ingredient.dart';
import 'package:calworries/features/meals/data/models/meal.dart';
import 'package:calworries/features/shopping/data/models/grocery_item.dart';
import 'package:calworries/features/shopping/data/models/shopping_list_item.dart';
import 'package:calworries/features/shopping/data/models/spending_record.dart';

class HiveService {
  static const String mealsBox = 'meals';
  static const String ingredientsBox = 'ingredients';
  static const String groceriesBox = 'groceries';
  static const String shoppingListBox = 'shopping_list';
  static const String spendingBox = 'spending';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(IngredientAdapter());
    Hive.registerAdapter(MealAdapter());
    Hive.registerAdapter(GroceryItemAdapter());
    Hive.registerAdapter(ShoppingListItemAdapter());
    Hive.registerAdapter(SpendingRecordAdapter());

    await Hive.openBox<Meal>(mealsBox);
    await Hive.openBox<Ingredient>(ingredientsBox);
    await Hive.openBox<GroceryItem>(groceriesBox);
    await Hive.openBox<ShoppingListItem>(shoppingListBox);
    await Hive.openBox<SpendingRecord>(spendingBox);
  }

  static Box<Meal> getMealsBox() => Hive.box<Meal>(mealsBox);
  static Box<Ingredient> getIngredientsBox() =>
      Hive.box<Ingredient>(ingredientsBox);
  static Box<GroceryItem> getGroceriesBox() =>
      Hive.box<GroceryItem>(groceriesBox);
  static Box<ShoppingListItem> getShoppingListBox() =>
      Hive.box<ShoppingListItem>(shoppingListBox);
  static Box<SpendingRecord> getSpendingBox() =>
      Hive.box<SpendingRecord>(spendingBox);
}
