import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'grocery_item.g.dart';

@HiveType(typeId: 2)
class GroceryItem extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String unit;

  @HiveField(4)
  final int category;

  @HiveField(5)
  final DateTime lastPurchased;

  @HiveField(6)
  final int estimatedDaysToEmpty;

  @HiveField(7)
  final int usageFrequency;

  GroceryItem({
    String? id,
    required this.name,
    this.quantity = 1,
    this.unit = 'unit',
    required this.category,
    DateTime? lastPurchased,
    this.estimatedDaysToEmpty = 30,
    this.usageFrequency = 0,
  }) : id = id ?? const Uuid().v4(),
       lastPurchased = lastPurchased ?? DateTime.now();

  @override
  List<Object?> get props => [
    id,
    name,
    quantity,
    unit,
    category,
    lastPurchased,
    estimatedDaysToEmpty,
    usageFrequency,
  ];

  GroceryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? unit,
    int? category,
    DateTime? lastPurchased,
    int? estimatedDaysToEmpty,
    int? usageFrequency,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      lastPurchased: lastPurchased ?? this.lastPurchased,
      estimatedDaysToEmpty: estimatedDaysToEmpty ?? this.estimatedDaysToEmpty,
      usageFrequency: usageFrequency ?? this.usageFrequency,
    );
  }
}
