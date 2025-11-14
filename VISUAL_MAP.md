# 🎨 Calworries - Visual Project Map

## 📊 Complete Project Structure

```
calworries/
│
├── 📚 DOCUMENTATION (Start here!)
│   ├── README.md                    ← Main overview
│   ├── COMPLETION_SUMMARY.md        ← What was built
│   ├── SETUP_GUIDE.md               ← How to setup
│   ├── DEPLOYMENT_GUIDE.md          ← How to deploy
│   ├── QUICK_REFERENCE.md           ← Cheat sheet
│   ├── ARCHITECTURE.md              ← Design patterns
│   ├── INDEX.md                     ← File navigation
│   └── FILE_MANIFEST.md             ← All files listed
│
├── 🔧 CONFIGURATION
│   ├── pubspec.yaml                 ← All dependencies
│   └── netlify.toml                 ← Netlify config
│
├── 🤖 AUTOMATION
│   └── .github/workflows/
│       ├── flutter_ci_cd.yml        ← Auto build & deploy
│       └── flutter_release.yml      ← Release automation
│
├── 📱 APPLICATION CODE
│   │
│   ├── lib/
│   │   │
│   │   ├── 🏗️ CORE LAYER
│   │   │   └── core/
│   │   │       ├── constants/
│   │   │       │   └── enums.dart   (MealCategory, GroceryCategory, HealthRating)
│   │   │       ├── services/
│   │   │       │   ├── hive_service.dart              (DB setup & initialization)
│   │   │       │   └── seed_data_provider.dart        (Test data)
│   │   │       └── theme/
│   │   │           └── app_theme.dart                 (Material Design 3)
│   │   │
│   │   ├── 🍽️ FEATURE: MEALS
│   │   │   └── features/meals/
│   │   │       ├── data/
│   │   │       │   ├── models/
│   │   │       │   │   ├── ingredient.dart            (Hive TypeId: 0)
│   │   │       │   │   └── meal.dart                  (Hive TypeId: 1)
│   │   │       │   └── datasources/                   (Extensible)
│   │   │       ├── domain/                            (Extensible)
│   │   │       └── presentation/
│   │   │           ├── widgets/
│   │   │           │   └── meal_logging_dialog.dart
│   │   │           └── screens/                       (Extensible)
│   │   │
│   │   ├── 🛒 FEATURE: SHOPPING
│   │   │   └── features/shopping/
│   │   │       ├── data/
│   │   │       │   ├── models/
│   │   │       │   │   ├── grocery_item.dart          (Hive TypeId: 2)
│   │   │       │   │   ├── shopping_list_item.dart    (Hive TypeId: 3)
│   │   │       │   │   └── spending_record.dart       (Hive TypeId: 4)
│   │   │       │   └── datasources/                   (Extensible)
│   │   │       ├── domain/                            (Extensible)
│   │   │       └── presentation/
│   │   │           ├── widgets/
│   │   │           │   ├── grocery_suggestion_dialog.dart
│   │   │           │   └── purchase_tracking_dialog.dart
│   │   │           └── screens/                       (Extensible)
│   │   │
│   │   ├── 📈 FEATURE: ANALYTICS
│   │   │   └── features/analytics/
│   │   │       ├── domain/                            (Extensible)
│   │   │       └── presentation/
│   │   │           ├── screens/
│   │   │           │   └── dashboard_screen.dart      (3-tab main UI)
│   │   │           └── widgets/                       (Extensible)
│   │   │
│   │   ├── 🔄 SHARED LAYER
│   │   │   └── shared/
│   │   │       ├── providers/
│   │   │       │   ├── meal_provider.dart             (State management)
│   │   │       │   ├── shopping_provider.dart         (State management)
│   │   │       │   └── spending_provider.dart         (State management)
│   │   │       └── widgets/                           (Extensible)
│   │   │
│   │   └── 🚀 ENTRY POINT
│   │       └── main.dart                              (App initialization)
│   │
│   └── test/
│       └── widget_test.dart                           (Extensible tests)
│
├── 📱 PLATFORM-SPECIFIC CODE
│   ├── android/                      (Android build)
│   ├── ios/                          (iOS build)
│   ├── web/                          (Web build)
│   ├── windows/                      (Windows build)
│   ├── linux/                        (Linux build)
│   └── macos/                        (macOS build)
│
└── 📦 BUILD OUTPUTS
    └── build/
        ├── apk/                      (Android APK)
        ├── web/                      (Web - deployed to Netlify)
        ├── ios/                      (iOS IPA)
        └── (other platforms...)
```

---

## 🔄 Data Flow Architecture

```
┌─────────────────────────────────────────────────────┐
│           USER INTERFACE LAYER                      │
│                                                     │
│  Dashboard (3 tabs)                                │
│  ├─ Overview: Daily summary                        │
│  ├─ Shopping: List management                      │
│  └─ Analytics: Charts & reports                    │
│                                                     │
│  Pop-up Dialogs                                    │
│  ├─ Meal Logging (meal + ingredients)             │
│  ├─ Grocery Suggestions (checkbox UI)             │
│  └─ Purchase Tracking (item + price)              │
└────────────────┬────────────────────────────────────┘
                 │
                 │ UI triggers
                 ▼
┌─────────────────────────────────────────────────────┐
│      STATE MANAGEMENT LAYER (Providers)            │
│                                                     │
│  ├─ MealProvider                                   │
│  │  ├─ addMeal(meal)                              │
│  │  ├─ getDailyCalories()                         │
│  │  └─ getMostUsedIngredients()                   │
│  │                                                 │
│  ├─ ShoppingProvider                              │
│  │  ├─ addToShoppingList()                        │
│  │  ├─ getItemsRunningLow()                       │
│  │  └─ getFrequentlyUsedItems()                   │
│  │                                                 │
│  └─ SpendingProvider                              │
│     ├─ addRecord()                                │
│     ├─ getMonthlySpending()                       │
│     └─ getSpendingByCategory()                    │
└────────────────┬────────────────────────────────────┘
                 │
                 │ save/load
                 ▼
┌─────────────────────────────────────────────────────┐
│        LOCAL DATABASE LAYER (Hive)                 │
│                                                     │
│  ├─ mealsBox (Meal objects)                        │
│  ├─ ingredientsBox (Ingredient objects)            │
│  ├─ groceriesBox (GroceryItem objects)            │
│  ├─ shoppingListBox (ShoppingListItem objects)    │
│  └─ spendingBox (SpendingRecord objects)          │
│                                                     │
│  All data persisted locally                        │
└─────────────────────────────────────────────────────┘
```

---

## 📋 Feature Flow Diagram

```
START APP
│
├─► OVERVIEW TAB
│   ├─ Show today's calorie total
│   ├─ Show today's meals list
│   ├─ Show monthly spending
│   └─ FABs: Log Meal, Record Purchase
│
├─► SHOPPING TAB
│   ├─ Show unpurchased items (To Buy)
│   └─ Show purchased items (Purchased)
│
└─► ANALYTICS TAB
    ├─ Show weekly calorie chart
    ├─ Show most used ingredients
    └─ Show spending breakdown

LOG MEAL FLOW:
├─ Tap FAB (+)
├─ MealLoggingDialog appears
│   ├─ Enter name
│   ├─ Enter calories
│   ├─ Select category
│   ├─ Select ingredients (multi)
│   ├─ Set health rating (slider)
│   └─ Add notes (optional)
├─ Save to database
├─ Update ingredient counts
├─ Notify listeners
├─ UI updates
└─ GrocerySuggestionDialog auto-appears
   ├─ Show frequent items
   ├─ User selects items
   └─ Add to shopping list

RECORD PURCHASE FLOW:
├─ Tap small FAB
├─ PurchaseTrackingDialog appears
│   ├─ Enter item name
│   ├─ Enter quantity & price
│   └─ Select category
├─ Save to database
├─ Notify listeners
└─ UI updates (spending total changes)

SHOPPING LIST FLOW:
├─ Navigate to Shopping tab
├─ View unpurchased items
├─ Toggle item checkbox
├─ Item moves to purchased
├─ Delete as needed
└─ Track spending automatically
```

---

## 🏛️ Architecture Layers

```
                    PRESENTATION LAYER
                   (User Interface)
    ┌───────────────────────────────────────────────┐
    │ DashboardScreen (3 tabs)                      │
    │ ├─ OverviewTab                                │
    │ ├─ ShoppingTab                                │
    │ └─ AnalyticsTab                               │
    │                                               │
    │ Dialogs                                       │
    │ ├─ MealLoggingDialog                          │
    │ ├─ GrocerySuggestionDialog                    │
    │ └─ PurchaseTrackingDialog                     │
    └───────────────────────────────────────────────┘
                        ▲
                        │ depends on
                        ▼
               STATE MANAGEMENT LAYER
            (Business Logic & Data Flow)
    ┌───────────────────────────────────────────────┐
    │ Providers (with ChangeNotifier)               │
    │ ├─ MealProvider                               │
    │ │  ├─ _meals: List<Meal>                     │
    │ │  └─ business logic methods                 │
    │ ├─ ShoppingProvider                           │
    │ │  ├─ _groceries: List<GroceryItem>          │
    │ │  ├─ _shoppingList: List<ShoppingListItem>  │
    │ │  └─ business logic methods                 │
    │ └─ SpendingProvider                           │
    │    ├─ _records: List<SpendingRecord>         │
    │    └─ business logic methods                 │
    └───────────────────────────────────────────────┘
                        ▲
                        │ depends on
                        ▼
                    DATA LAYER
            (Models & Database)
    ┌───────────────────────────────────────────────┐
    │ Models (Hive)                                 │
    │ ├─ Meal (TypeId: 1)                           │
    │ ├─ Ingredient (TypeId: 0)                     │
    │ ├─ GroceryItem (TypeId: 2)                    │
    │ ├─ ShoppingListItem (TypeId: 3)               │
    │ └─ SpendingRecord (TypeId: 4)                 │
    │                                               │
    │ Database                                      │
    │ ├─ mealsBox                                   │
    │ ├─ ingredientsBox                             │
    │ ├─ groceriesBox                               │
    │ ├─ shoppingListBox                            │
    │ └─ spendingBox                                │
    └───────────────────────────────────────────────┘
                        ▲
                        │ uses
                        ▼
                   CORE LAYER
            (Services & Utilities)
    ┌───────────────────────────────────────────────┐
    │ Services                                      │
    │ ├─ HiveService (database init)               │
    │ └─ SeedDataProvider (test data)              │
    │                                               │
    │ Theme                                         │
    │ └─ AppTheme (Material Design 3)              │
    │                                               │
    │ Constants                                     │
    │ └─ Enums (categories, ratings)               │
    └───────────────────────────────────────────────┘
```

---

## 🚀 Deployment Pipeline

```
Source Code (GitHub)
│
├─► Push to main branch
│
└─► GitHub Actions Triggers
    │
    ├─► Job: Analyze
    │   └─ flutter analyze
    │
    ├─► Job: Test
    │   └─ flutter test
    │
    ├─► Job: Build APK
    │   └─ flutter build apk --release
    │
    ├─► Job: Build Web
    │   └─ flutter build web --release
    │
    └─► Job: Deploy to Netlify (main only)
        │
        ├─ Upload build/web/
        │
        └─► LIVE! 🚀
            https://your-site.netlify.app
```

---

## 📱 UI Layout Map

### Overview Tab
```
┌─────────────────────────────┐
│ Today's Calories: 2150 kcal  │ ← Card with big number
├─────────────────────────────┤
│ Weekly: 15,200 kcal         │ ← Small stat
├─────────────────────────────┤
│ Today's Meals:              │ ← Section header
├─────────────────────────────┤
│ [Meal 1] 550 kcal | Lunch   │ ← ListTile
├─────────────────────────────┤
│ [Meal 2] 350 kcal | Snack   │ ← ListTile
├─────────────────────────────┤
│ Monthly Spending: ₹2,450    │ ← Card with big number
└─────────────────────────────┘
```

### Shopping Tab
```
┌──────────────────────────┐
│ To Buy (3)   Purchased(2)│ ← TabBar
├──────────────────────────┤
│ ☐ Chicken 1 kg          │ ← CheckboxListTile
│ ☐ Rice 5 kg             │
│ ☐ Eggs 12 pieces        │
│                          │
│          ▼ Tab switch ▼  │
│                          │
│ ☑ Milk 1L               │ ← Checked (strikethrough)
│ ☑ Veggies 2 kg          │
└──────────────────────────┘
```

### Analytics Tab
```
┌──────────────────────────┐
│ Weekly Calorie Trend     │ ← Header
├──────────────────────────┤
│        /\                │ ← Line Chart
│       /  \              │
│      /    \             │
│     /      \            │ ← FlChart LineChart
│                          │
├──────────────────────────┤
│ Most Used Ingredients    │ ← Header
├──────────────────────────┤
│ Chicken       5 times    │
│ Rice          4 times    │
│ Vegetables    3 times    │
│                          │
├──────────────────────────┤
│ Monthly Spending: ₹5,200 │ ← Card
└──────────────────────────┘
```

---

## 🎨 Color Scheme

```
PRIMARY PALETTE
┌──────────┐
│ #6366F1  │ Indigo (Primary action)
└──────────┘

SECONDARY PALETTE
┌──────────┐
│ #8B5CF6  │ Purple (Accents)
└──────────┘

SEMANTIC COLORS
┌──────────────────────────┐
│ #10B981  Green (Success) │
│ #F59E0B  Amber (Warning) │
│ #EF4444  Red (Error)     │
│ #3B82F6  Blue (Info)     │
└──────────────────────────┘

NEUTRAL SCALE
┌──────────────────────────┐
│ #FAFAFA  Background      │
│ #FFFFFF  Surface/Cards   │
│ #F3F4F6  Variants        │
│ #1F2937  Text Primary    │
│ #6B7280  Text Secondary  │
│ #9CA3AF  Text Tertiary   │
└──────────────────────────┘
```

---

## 📊 Database Size Reference

```
Example with 30 days of data:

Meals: ~60 entries (2/day avg)
├─ Storage: ~60KB
└─ Each meal: ~1KB

Ingredients: ~15 entries
├─ Storage: ~5KB
└─ Each: ~300B

Groceries: ~20 entries
├─ Storage: ~8KB
└─ Each: ~400B

Shopping List: ~5 entries
├─ Storage: ~2KB
└─ Each: ~400B

Spending: ~50 entries
├─ Storage: ~12KB
└─ Each: ~250B

TOTAL: ~87KB (very efficient!)
```

---

## ✅ File Organization Checklist

```
Documentation Files (8) ✓
├─ README.md
├─ PROJECT_SUMMARY.md
├─ SETUP_GUIDE.md
├─ DEPLOYMENT_GUIDE.md
├─ QUICK_REFERENCE.md
├─ ARCHITECTURE.md
├─ INDEX.md
└─ FILE_MANIFEST.md

Configuration (2) ✓
├─ pubspec.yaml
└─ netlify.toml

GitHub Workflows (2) ✓
├─ flutter_ci_cd.yml
└─ flutter_release.yml

Core Files (4) ✓
├─ enums.dart
├─ hive_service.dart
├─ seed_data_provider.dart
└─ app_theme.dart

Feature Files (7) ✓
├─ Meals: 2 models + 1 dialog
├─ Shopping: 3 models + 2 dialogs
└─ Analytics: 1 screen

Providers (3) ✓
├─ meal_provider.dart
├─ shopping_provider.dart
└─ spending_provider.dart

Main (1) ✓
└─ main.dart

TOTAL: 28 Files ✓
```

---

**Every part of your app, from code to deployment, is mapped above! 🗺️**

**Start with README.md and refer back to this visual map whenever needed! 📍**
