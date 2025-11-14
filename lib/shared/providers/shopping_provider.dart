import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:calworries/features/shopping/data/models/grocery_item.dart';
import 'package:calworries/features/shopping/data/models/shopping_list_item.dart';
import 'package:calworries/core/services/hive_service.dart';

class ShoppingProvider extends ChangeNotifier {
  List<GroceryItem> _groceries = [];
  List<ShoppingListItem> _shoppingList = [];

  List<GroceryItem> get groceries => _groceries;
  List<ShoppingListItem> get shoppingList => _shoppingList;
  List<ShoppingListItem> get unpurchasedItems =>
      _shoppingList.where((item) => !item.isPurchased).toList();
  List<ShoppingListItem> get purchasedItems =>
      _shoppingList.where((item) => item.isPurchased).toList();

  ShoppingProvider() {
    _loadGroceries();
    _loadShoppingList();
  }

  void _loadGroceries() {
    try {
      final box = HiveService.getGroceriesBox();
      _groceries = box.values.toList();
    } catch (e) {
      print('Error loading groceries: $e');
    }
  }

  void _loadShoppingList() {
    try {
      final box = HiveService.getShoppingListBox();
      _shoppingList = box.values.toList();
      _shoppingList.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    } catch (e) {
      print('Error loading shopping list: $e');
    }
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    try {
      final box = HiveService.getGroceriesBox();
      await box.put(item.id, item);
      _loadGroceries();
      notifyListeners();
    } catch (e) {
      print('Error adding grocery: $e');
    }
  }

  Future<void> updateGroceryItem(GroceryItem item) async {
    try {
      final box = HiveService.getGroceriesBox();
      await box.put(item.id, item);
      _loadGroceries();
      notifyListeners();
    } catch (e) {
      print('Error updating grocery: $e');
    }
  }

  Future<void> deleteGroceryItem(String itemId) async {
    try {
      final box = HiveService.getGroceriesBox();
      await box.delete(itemId);
      _loadGroceries();
      notifyListeners();
    } catch (e) {
      print('Error deleting grocery: $e');
    }
  }

  Future<void> addToShoppingList(ShoppingListItem item) async {
    try {
      final box = HiveService.getShoppingListBox();
      await box.put(item.id, item);
      _loadShoppingList();
      notifyListeners();
    } catch (e) {
      print('Error adding to shopping list: $e');
    }
  }

  Future<void> removeFromShoppingList(String itemId) async {
    try {
      final box = HiveService.getShoppingListBox();
      await box.delete(itemId);
      _loadShoppingList();
      notifyListeners();
    } catch (e) {
      print('Error removing from shopping list: $e');
    }
  }

  Future<void> toggleShoppingItem(ShoppingListItem item) async {
    try {
      final updated = item.copyWith(isPurchased: !item.isPurchased);
      final box = HiveService.getShoppingListBox();
      await box.put(item.id, updated);
      _loadShoppingList();
      notifyListeners();
    } catch (e) {
      print('Error toggling shopping item: $e');
    }
  }

  List<GroceryItem> getItemsRunningLow() {
    return _groceries.where((item) => item.estimatedDaysToEmpty <= 3).toList();
  }

  List<GroceryItem> getFrequentlyUsedItems({int limit = 10}) {
    final sorted = List<GroceryItem>.from(_groceries);
    sorted.sort((a, b) => b.usageFrequency.compareTo(a.usageFrequency));
    return sorted.take(limit).toList();
  }
}
