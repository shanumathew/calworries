import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:calworries/shared/providers/meal_provider.dart';
import 'package:calworries/shared/providers/shopping_provider.dart';
import 'package:calworries/shared/providers/spending_provider.dart';
import 'package:calworries/features/meals/presentation/widgets/meal_logging_dialog.dart';
import 'package:calworries/features/shopping/presentation/widgets/purchase_tracking_dialog.dart';
import 'package:calworries/features/shopping/presentation/widgets/grocery_suggestion_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _showMealLoggingDialog() {
    showDialog(
      context: context,
      builder: (context) => MealLoggingDialog(
        onSave: (meal) {
          context.read<MealProvider>().addMeal(meal);
          _showGrocerySuggestion();
        },
      ),
    );
  }

  void _showGrocerySuggestion() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return;

      final shoppingProvider = context.read<ShoppingProvider>();
      final suggestions = shoppingProvider.getFrequentlyUsedItems();

      if (suggestions.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => GrocerySuggestionDialog(
            suggestions: suggestions,
            onAddToCart: (items) {
              for (var item in items) {
                shoppingProvider.addToShoppingList(item);
              }
            },
          ),
        );
      }
    });
  }

  void _showPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => PurchaseTrackingDialog(
        onSave: (record) {
          context.read<SpendingProvider>().addRecord(record);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calworries'), elevation: 0),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildOverviewTab(),
          _buildShoppingTab(),
          _buildAnalyticsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Overview'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'purchase',
            onPressed: _showPurchaseDialog,
            tooltip: 'Record Purchase',
            child: const Icon(Icons.receipt),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'meal',
            onPressed: _showMealLoggingDialog,
            tooltip: 'Log Meal',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer3<MealProvider, ShoppingProvider, SpendingProvider>(
      builder: (context, mealProvider, shoppingProvider, spendingProvider, _) {
        final today = DateTime.now();
        final dailyCalories = mealProvider.getDailyCalories(today);
        final weeklyCalories = mealProvider.getWeeklyCalories();
        final todayMeals = mealProvider.getMealsByDate(today);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Calories',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '$dailyCalories',
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'kcal',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$weeklyCalories kcal this week',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Today\'s Meals',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              todayMeals.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No meals logged today',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todayMeals.length,
                      itemBuilder: (context, index) {
                        final meal = todayMeals[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(meal.name),
                            subtitle: Text(
                              '${meal.calories} kcal • ${meal.category.displayName}',
                            ),
                            trailing: Text(meal.health.displayName),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Month\'s Spending',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '₹${spendingProvider.getMonthlySpending().toStringAsFixed(2)}',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShoppingTab() {
    return Consumer<ShoppingProvider>(
      builder: (context, shoppingProvider, _) {
        final unpurchased = shoppingProvider.unpurchasedItems;
        final purchased = shoppingProvider.purchasedItems;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              tabs: [
                Tab(text: 'To Buy (${unpurchased.length})'),
                Tab(text: 'Purchased (${purchased.length})'),
              ],
            ),
            body: TabBarView(
              children: [
                unpurchased.isEmpty
                    ? Center(
                        child: Text(
                          'No items in shopping list',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: unpurchased.length,
                        itemBuilder: (context, index) {
                          final item = unpurchased[index];
                          return CheckboxListTile(
                            value: false,
                            onChanged: (_) =>
                                shoppingProvider.toggleShoppingItem(item),
                            title: Text(item.itemName),
                            subtitle: Text('${item.quantity} ${item.unit}'),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => shoppingProvider
                                  .removeFromShoppingList(item.id),
                            ),
                          );
                        },
                      ),
                purchased.isEmpty
                    ? Center(
                        child: Text(
                          'No purchased items',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: purchased.length,
                        itemBuilder: (context, index) {
                          final item = purchased[index];
                          return CheckboxListTile(
                            value: true,
                            onChanged: (_) =>
                                shoppingProvider.toggleShoppingItem(item),
                            title: Text(
                              item.itemName,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            subtitle: Text('${item.quantity} ${item.unit}'),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => shoppingProvider
                                  .removeFromShoppingList(item.id),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer3<MealProvider, ShoppingProvider, SpendingProvider>(
      builder: (context, mealProvider, shoppingProvider, spendingProvider, _) {
        final mostUsedIngredients = mealProvider.getMostUsedIngredients();
        final monthlySpending = spendingProvider.getMonthlySpending();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Calorie Trend',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(show: true),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 2000),
                                  FlSpot(1, 2200),
                                  FlSpot(2, 2100),
                                  FlSpot(3, 2300),
                                  FlSpot(4, 2000),
                                  FlSpot(5, 2400),
                                  FlSpot(6, 2100),
                                ],
                                isCurved: true,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Most Used Ingredients',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      ...mostUsedIngredients.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text('${entry.value} times'),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Spending',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '₹${monthlySpending.toStringAsFixed(2)}',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
