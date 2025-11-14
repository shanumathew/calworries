import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'spending_record.g.dart';

@HiveType(typeId: 4)
class SpendingRecord extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String itemName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String unit;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int category;

  @HiveField(6)
  final DateTime purchasedAt;

  SpendingRecord({
    String? id,
    required this.itemName,
    this.quantity = 1,
    this.unit = 'unit',
    required this.price,
    required this.category,
    DateTime? purchasedAt,
  }) : id = id ?? const Uuid().v4(),
       purchasedAt = purchasedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    id,
    itemName,
    quantity,
    unit,
    price,
    category,
    purchasedAt,
  ];

  SpendingRecord copyWith({
    String? id,
    String? itemName,
    int? quantity,
    String? unit,
    double? price,
    int? category,
    DateTime? purchasedAt,
  }) {
    return SpendingRecord(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      category: category ?? this.category,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }

  double get totalCost => price * quantity;
}
