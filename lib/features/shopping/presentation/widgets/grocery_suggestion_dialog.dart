import 'package:flutter/material.dart';
import 'package:calworries/features/shopping/data/models/grocery_item.dart';
import 'package:calworries/features/shopping/data/models/shopping_list_item.dart';

class GrocerySuggestionDialog extends StatefulWidget {
  final List<GroceryItem> suggestions;
  final Function(List<ShoppingListItem>) onAddToCart;

  const GrocerySuggestionDialog({
    Key? key,
    required this.suggestions,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<GrocerySuggestionDialog> createState() =>
      _GrocerySuggestionDialogState();
}

class _GrocerySuggestionDialogState extends State<GrocerySuggestionDialog> {
  late Set<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = {};
  }

  void _addToCart() {
    final itemsToAdd = widget.suggestions
        .where((item) => _selectedItems.contains(item.id))
        .map(
          (item) => ShoppingListItem(
            groceryItemId: item.id,
            itemName: item.name,
            quantity: 1,
            unit: item.unit,
          ),
        )
        .toList();

    widget.onAddToCart(itemsToAdd);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested Groceries',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Based on your recent meals and stock prediction',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: widget.suggestions.length,
                itemBuilder: (context, index) {
                  final item = widget.suggestions[index];
                  final isSelected = _selectedItems.contains(item.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value ?? false) {
                          _selectedItems.add(item.id);
                        } else {
                          _selectedItems.remove(item.id);
                        }
                      });
                    },
                    title: Text(item.name),
                    subtitle: Text(
                      'Est. runs out: ${item.estimatedDaysToEmpty} days',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Skip'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addToCart,
                  child: Text('Add ${_selectedItems.length} to Cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
