enum MealCategory { breakfast, lunch, dinner, snack, drink }

enum GroceryCategory { protein, carbs, veggies, fruits, dairy, pantry, other }

enum HealthRating { poor, fair, good, excellent }

extension MealCategoryExtension on MealCategory {
  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }
}

extension GroceryCategoryExtension on GroceryCategory {
  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }
}

extension HealthRatingExtension on HealthRating {
  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  int get value {
    return index + 1;
  }
}
