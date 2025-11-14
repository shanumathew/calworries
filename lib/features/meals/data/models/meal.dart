import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'ingredient.dart';
import '../../../core/constants/enums.dart';

part 'meal.g.dart';

@HiveType(typeId: 1)
class Meal extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final int mealCategory;

  @HiveField(4)
  final List<Ingredient> ingredients;

  @HiveField(5)
  final int healthRating;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final DateTime createdAt;

  Meal({
    String? id,
    required this.name,
    required this.calories,
    required this.mealCategory,
    required this.ingredients,
    required this.healthRating,
    this.notes,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    id,
    name,
    calories,
    mealCategory,
    ingredients,
    healthRating,
    notes,
    createdAt,
  ];

  Meal copyWith({
    String? id,
    String? name,
    int? calories,
    int? mealCategory,
    List<Ingredient>? ingredients,
    int? healthRating,
    String? notes,
    DateTime? createdAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      mealCategory: mealCategory ?? this.mealCategory,
      ingredients: ingredients ?? this.ingredients,
      healthRating: healthRating ?? this.healthRating,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  MealCategory get category => MealCategory.values[mealCategory];
  HealthRating get health => HealthRating.values[healthRating];
}
