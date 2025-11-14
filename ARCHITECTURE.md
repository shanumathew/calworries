# Calworries - Architecture & System Design

## 🏛️ Clean Architecture Layers

```
┌────────────────────────────────────────────────────┐
│          PRESENTATION LAYER                        │
│  ┌──────────────────────────────────────────────┐  │
│  │ Screens, Dialogs, Widgets (UI Components)   │  │
│  │                                              │  │
│  │  • DashboardScreen (3 tabs)                 │  │
│  │  • MealLoggingDialog                        │  │
│  │  • GrocerySuggestionDialog                  │  │
│  │  • PurchaseTrackingDialog                   │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────┘
                         △
                         │ depends on
                         ▽
┌────────────────────────────────────────────────────┐
│      STATE MANAGEMENT LAYER (Provider)            │
│  ┌──────────────────────────────────────────────┐  │
│  │ Business Logic & State (ChangeNotifier)     │  │
│  │                                              │  │
│  │  • MealProvider                             │  │
│  │  • ShoppingProvider                         │  │
│  │  • SpendingProvider                         │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────┘
                         △
                         │ depends on
                         ▼
┌────────────────────────────────────────────────────┐
│       DATA LAYER (Hive + Models)                   │
│  ┌──────────────────────────────────────────────┐  │
│  │ Models & Database (Hive)                    │  │
│  │                                              │  │
│  │  • Meal (TypeId: 1)                         │  │
│  │  • Ingredient (TypeId: 0)                   │  │
│  │  • GroceryItem (TypeId: 2)                  │  │
│  │  • ShoppingListItem (TypeId: 3)             │  │
│  │  • SpendingRecord (TypeId: 4)               │  │
│  │                                              │  │
│  │  Boxes: meals, ingredients, groceries,      │  │
│  │         shopping_list, spending              │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────┘
                         △
                         │ uses
                         ▼
┌────────────────────────────────────────────────────┐
│          CORE UTILITIES LAYER                      │
│  ┌──────────────────────────────────────────────┐  │
│  │ Services, Theme, Constants, Enums           │  │
│  │                                              │  │
│  │  • HiveService (init, box management)       │  │
│  │  • AppTheme (Material Design 3)             │  │
│  │  • Enums (MealCategory, etc.)               │  │
│  │  • SeedDataProvider (test data)             │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────┘
```

## 🔄 Data Flow Architecture

```
User Interaction
    │
    ▼
┌─────────────────────────────────┐
│  Dialog Widget                  │
│ (MealLoggingDialog, etc.)       │
│                                 │
│  Collects user input            │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Validation                     │
│                                 │
│  Check required fields          │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Create Model                   │
│                                 │
│  Build Meal/ShoppingListItem    │
│  with provided data             │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Call Provider Method           │
│                                 │
│  addMeal(), addRecord(), etc.   │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Provider Business Logic        │
│                                 │
│  Process data, update related   │
│  fields (e.g., ingredient      │
│  usage count)                   │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Save to Hive                   │
│                                 │
│  box.put(id, model)             │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Notify Listeners               │
│                                 │
│  notifyListeners()              │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Rebuild Consumer Widgets       │
│                                 │
│  UI automatically updates       │
│  with new data                  │
└─────────────────────────────────┘
```

## 🎯 Feature Module Structure (Example: Meals)

```
features/meals/
│
├── data/
│   ├── datasources/              # Repository implementations
│   │   ├── meal_local_datasource.dart
│   │   └── ingredient_local_datasource.dart
│   │
│   ├── models/                   # Hive models
│   │   ├── meal.dart (@HiveType 1)
│   │   └── ingredient.dart (@HiveType 0)
│   │
│   └── repositories/             # Repository abstractions
│       └── meal_repository.dart
│
├── domain/
│   ├── entities/                 # Pure business objects
│   │   └── meal_entity.dart
│   │
│   ├── repositories/             # Abstract interfaces
│   │   └── meal_repository.dart
│   │
│   └── usecases/                 # Business logic
│       ├── add_meal.dart
│       ├── get_daily_calories.dart
│       └── get_most_used_ingredients.dart
│
└── presentation/
    ├── providers/                # State management
    │   └── meal_provider.dart
    │
    ├── screens/
    │   └── meals_screen.dart
    │
    └── widgets/
        └── meal_logging_dialog.dart
```

## 📊 Provider Pattern Flow

```
┌─────────────┐
│  Consumer   │──────────┐
│  (Widget)   │          │
└─────────────┘          │
                         │ watches
                         ▼
            ┌────────────────────────┐
            │   ChangeNotifier       │
            │   (Provider)           │
            │                        │
            │  • _meals: List        │
            │  • _ingredients: List  │
            │                        │
            │  • addMeal()           │
            │  • deleteMeal()        │
            │  • notifyListeners()   │
            │                        │
            └────────┬───────────────┘
                     │ reads/writes
                     ▼
            ┌────────────────────────┐
            │   Hive Database        │
            │                        │
            │  • mealsBox            │
            │  • ingredientsBox      │
            │                        │
            └────────────────────────┘
```

## 🗄️ Database Schema (Hive)

```
HiveBox: "mealsBox"
├─ Key: UUID (meal.id)
├─ Value: Meal
│   ├─ id: String
│   ├─ name: String
│   ├─ calories: int
│   ├─ mealCategory: int (0-4)
│   ├─ ingredients: List<Ingredient>
│   │   ├─ id: String
│   │   ├─ name: String
│   │   ├─ quantity: int
│   │   ├─ unit: String
│   │   ├─ lastUsed: DateTime
│   │   └─ usageCount: int
│   ├─ healthRating: int (0-3)
│   ├─ notes: String?
│   └─ createdAt: DateTime
│
└─ Example Entry:
   Key: "550e8400-e29b-41d4-a716-446655440000"
   Value: Meal(
     id: "550e8400-e29b-41d4-a716-446655440000",
     name: "Grilled Chicken",
     calories: 550,
     mealCategory: 1,  // lunch
     ingredients: [
       Ingredient(
         id: "xxx",
         name: "Chicken",
         quantity: 200,
         unit: "g",
         lastUsed: DateTime.now(),
         usageCount: 5
       ),
       ...
     ],
     healthRating: 3,  // excellent
     notes: null,
     createdAt: DateTime.now()
   )
```

## 🔌 Widget Dependency Tree

```
MyApp (root)
│
├── MultiProvider
│   ├── ChangeNotifierProvider(MealProvider)
│   ├── ChangeNotifierProvider(ShoppingProvider)
│   └── ChangeNotifierProvider(SpendingProvider)
│
└── MaterialApp
    └── DashboardScreen
        │
        ├── BottomNavigationBar
        │   └── _selectedIndex (0, 1, 2)
        │
        ├── IndexedStack
        │   ├── OverviewTab
        │   │   └── Consumer3<MealProvider, ShoppingProvider, SpendingProvider>
        │   │       └── Cards, Lists, Summaries
        │   │
        │   ├── ShoppingTab
        │   │   └── Consumer<ShoppingProvider>
        │   │       ├── TabBar (To Buy, Purchased)
        │   │       └── TabBarView
        │   │           ├── ListView (unpurchased)
        │   │           └── ListView (purchased)
        │   │
        │   └── AnalyticsTab
        │       └── Consumer3<MealProvider, ShoppingProvider, SpendingProvider>
        │           ├── LineChart (calories trend)
        │           ├── Bar chart (spending)
        │           └── Lists (ingredients, spending)
        │
        ├── FloatingActionButton (Log Meal)
        │   └── showDialog(MealLoggingDialog)
        │       ├── TextField (name, calories)
        │       ├── Wrap<ChoiceChip> (category)
        │       ├── Wrap<FilterChip> (ingredients)
        │       ├── Slider (health rating)
        │       └── TextField (notes)
        │
        └── FloatingActionButton.small (Record Purchase)
            └── showDialog(PurchaseTrackingDialog)
                ├── TextField (item name)
                ├── Row of TextFields (quantity, price)
                ├── Wrap<ChoiceChip> (category)
                └── Buttons (Cancel, Save)
```

## 📈 State Synchronization

```
┌─────────────────────────────────┐
│  User Action in MealLoggingDialog │
└────────────────┬────────────────┘
                 │
                 ▼
        ┌──────────────────┐
        │  Save Meal       │
        │  (Dialog closes) │
        └────────┬─────────┘
                 │
                 ▼
┌────────────────────────────────────────┐
│  MealProvider.addMeal()               │
│  • Adds meal to _meals list           │
│  • Updates ingredient usageCount      │
│  • Calls box.put(meal.id, meal)       │
│  • Calls notifyListeners()            │
└────────────────┬─────────────────────┘
                 │
                 ▼ triggers
┌────────────────────────────────────────┐
│  All Consumer<MealProvider> rebuild   │
│  • OverviewTab (day summary)          │
│  • AnalyticsTab (charts)              │
│  • GrocerySuggestionDialog loads      │
└────────────────────────────────────────┘
```

## 🔐 Hive Type ID Allocation

```
TypeId 0 → Ingredient (core building block)
TypeId 1 → Meal (primary aggregate)
TypeId 2 → GroceryItem (inventory)
TypeId 3 → ShoppingListItem (shopping interface)
TypeId 4 → SpendingRecord (financial)

Why this order?
- 0: Ingredient is embedded in Meal
- 1: Meal is most frequently accessed
- 2-4: Shopping-related types grouped
```

## 🎨 Theme Architecture

```
AppTheme
│
├── AppColors
│   ├── Primary colors (indigo, purple)
│   ├── Semantic colors (success, warning, error)
│   ├── Neutral scale (background, surface, text)
│   └── Aliases for consistency
│
└── lightTheme()
    ├── ColorScheme
    ├── AppBarTheme (styling for top bar)
    ├── CardThemeData (Card components)
    ├── InputDecorationTheme (TextField styling)
    ├── ElevatedButtonThemeData (Button style)
    ├── OutlinedButtonThemeData (Secondary buttons)
    └── TextTheme (6 text styles)
```

## 🚀 Deployment Pipeline

```
┌──────────────────────────────────────┐
│  Developer Push to GitHub            │
│  git push origin main                │
└────────────────┬─────────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │ GitHub Actions │
        │  flutter_ci_cd │
        └────────┬───────┘
                 │
         ┌───────┼───────┐
         │       │       │
         ▼       ▼       ▼
    ┌────────┐ ┌────┐ ┌──────┐
    │Analyze │ │Test│ │Build │
    └────────┘ └────┘ └──────┘
         │       │       │
         └───────┼───────┘
                 │
                 ▼
         ┌──────────────┐
         │ Build Web    │
         │ (Flutter web)│
         └──────┬───────┘
                │
                ▼
    ┌────────────────────────┐
    │ Deploy to Netlify      │
    │ (Auto on main branch)  │
    └────────┬───────────────┘
             │
             ▼
    ┌────────────────────────┐
    │ App Live at URL        │
    │ https://site.netlify   │
    └────────────────────────┘
```

## 📱 Multi-Platform Build Output

```
flutter build [target] --release

Android:
└── build/app/outputs/
    ├── flutter-apk/app-release.apk
    └── bundle/release/app-release.aab

iOS:
└── build/ios/iphoneos/
    └── Runner.app

Web:
└── build/web/
    ├── index.html
    ├── main.dart.js
    ├── canvaskit/
    └── assets/

Windows:
└── build/windows/runner/Release/
    └── calworries.exe
```

---

**Architecture designed for scalability, maintainability, and rapid development!**
