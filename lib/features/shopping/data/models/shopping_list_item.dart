import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'shopping_list_item.g.dart';

@HiveType(typeId: 3)
class ShoppingListItem extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String groceryItemId;

  @HiveField(2)
  final String itemName;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String unit;

  @HiveField(5)
  final bool isPurchased;

  @HiveField(6)
  final DateTime addedAt;

  ShoppingListItem({
    String? id,
    required this.groceryItemId,
    required this.itemName,
    this.quantity = 1,
    this.unit = 'unit',
    this.isPurchased = false,
    DateTime? addedAt,
  }) : id = id ?? const Uuid().v4(),
       addedAt = addedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    id,
    groceryItemId,
    itemName,
    quantity,
    unit,
    isPurchased,
    addedAt,
  ];

  ShoppingListItem copyWith({
    String? id,
    String? groceryItemId,
    String? itemName,
    int? quantity,
    String? unit,
    bool? isPurchased,
    DateTime? addedAt,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      groceryItemId: groceryItemId ?? this.groceryItemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isPurchased: isPurchased ?? this.isPurchased,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
