import 'package:flutter/material.dart';
import 'package:calworries/core/constants/enums.dart';
import 'package:calworries/features/meals/data/models/meal.dart';
import 'package:calworries/features/meals/data/models/ingredient.dart';

class MealLoggingDialog extends StatefulWidget {
  final Function(Meal) onSave;

  const MealLoggingDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  State<MealLoggingDialog> createState() => _MealLoggingDialogState();
}

class _MealLoggingDialogState extends State<MealLoggingDialog> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();

  MealCategory _selectedCategory = MealCategory.lunch;
  HealthRating _selectedHealth = HealthRating.good;
  Set<String> _selectedIngredients = {};

  final List<String> _commonIngredients = [
    'Chicken',
    'Rice',
    'Eggs',
    'Milk',
    'Bread',
    'Pasta',
    'Beef',
    'Fish',
    'Vegetables',
    'Fruits',
    'Oil',
    'Salt',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    if (_nameController.text.isEmpty || _caloriesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    final ingredients = _selectedIngredients
        .map((name) => Ingredient(name: name))
        .toList();

    final meal = Meal(
      name: _nameController.text,
      calories: int.parse(_caloriesController.text),
      mealCategory: _selectedCategory.index,
      ingredients: ingredients,
      healthRating: _selectedHealth.index,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    widget.onSave(meal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Meal', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'What did you eat?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Meal Category',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: MealCategory.values
                    .map(
                      (category) => ChoiceChip(
                        label: Text(category.displayName),
                        selected: _selectedCategory == category,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Ingredients Used',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonIngredients
                    .map(
                      (ingredient) => FilterChip(
                        label: Text(ingredient),
                        selected: _selectedIngredients.contains(ingredient),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedIngredients.add(ingredient);
                            } else {
                              _selectedIngredients.remove(ingredient);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Health Rating: ${_selectedHealth.displayName}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _selectedHealth.index.toDouble(),
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  setState(
                    () => _selectedHealth = HealthRating.values[value.toInt()],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveMeal,
                    child: const Text('Save Meal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
