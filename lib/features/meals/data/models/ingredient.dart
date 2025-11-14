import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 0)
class Ingredient extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String unit;

  @HiveField(4)
  final DateTime lastUsed;

  @HiveField(5)
  final int usageCount;

  Ingredient({
    String? id,
    required this.name,
    this.quantity = 1,
    this.unit = 'unit',
    DateTime? lastUsed,
    this.usageCount = 0,
  }) : id = id ?? const Uuid().v4(),
       lastUsed = lastUsed ?? DateTime.now();

  @override
  List<Object?> get props => [id, name, quantity, unit, lastUsed, usageCount];

  Ingredient copyWith({
    String? id,
    String? name,
    int? quantity,
    String? unit,
    DateTime? lastUsed,
    int? usageCount,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
