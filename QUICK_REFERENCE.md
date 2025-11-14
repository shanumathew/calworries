# Calworries - Quick Reference Card

## 🚀 Getting Started (30 seconds)

```bash
cd calworries
flutter pub get
flutter pub run build_runner build
flutter run
```

## 📁 Project Structure (Key Files)

| Path | Purpose |
|------|---------|
| `lib/main.dart` | App entry point with MultiProvider |
| `lib/core/theme/app_theme.dart` | All styling |
| `lib/features/*/data/models/` | Data models |
| `lib/shared/providers/` | State management |
| `lib/features/*/presentation/` | UI components |
| `.github/workflows/` | CI/CD pipelines |
| `netlify.toml` | Deployment config |

## 🗄️ Database (Hive Boxes)

| Box | Type ID | Models |
|-----|---------|--------|
| `mealsBox` | 1 | Meal |
| `ingredientsBox` | 0 | Ingredient |
| `groceriesBox` | 2 | GroceryItem |
| `shoppingListBox` | 3 | ShoppingListItem |
| `spendingBox` | 4 | SpendingRecord |

## 📱 UI Components

| Widget | Location | Purpose |
|--------|----------|---------|
| `DashboardScreen` | `features/analytics/screens/` | Main 3-tab interface |
| `MealLoggingDialog` | `features/meals/widgets/` | Meal input form |
| `GrocerySuggestionDialog` | `features/shopping/widgets/` | Suggestions popup |
| `PurchaseTrackingDialog` | `features/shopping/widgets/` | Purchase form |

## 🎛️ State Management (Provider)

| Provider | Key Methods |
|----------|-------------|
| `MealProvider` | `addMeal()`, `getDailyCalories()`, `getMostUsedIngredients()` |
| `ShoppingProvider` | `addToShoppingList()`, `getItemsRunningLow()`, `toggleShoppingItem()` |
| `SpendingProvider` | `addRecord()`, `getMonthlySpending()`, `getSpendingByCategory()` |

## 📦 Key Enums

```dart
enum MealCategory { breakfast, lunch, dinner, snack, drink }
enum GroceryCategory { protein, carbs, veggies, fruits, dairy, pantry, other }
enum HealthRating { poor, fair, good, excellent }
```

## 🔨 Common Commands

```bash
# Development
flutter run                          # Run app
flutter run -d web --debug          # Web debug
flutter run -d windows              # Windows

# Build
flutter build apk --release          # Android APK
flutter build web --release          # Web build
flutter build ios --release          # iOS build

# Code Generation
flutter pub run build_runner build   # Generate Hive adapters
flutter pub run build_runner clean   # Clean build files

# Testing & Analysis
flutter analyze                      # Static analysis
flutter test                         # Run tests
dart format lib/                     # Format code

# Cleanup
flutter clean                        # Clean all builds
flutter pub get                      # Get dependencies
```

## 🌐 Deployment Quick Steps

```bash
# 1. Create GitHub repo
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USER/calworries.git
git push -u origin main

# 2. Setup Netlify
# - Go to app.netlify.com
# - Import your GitHub repo
# - Set build: flutter build web --release
# - Set publish: build/web

# 3. Add GitHub Secrets
# - Go to Settings → Secrets → Actions
# - Add NETLIFY_AUTH_TOKEN
# - Add NETLIFY_SITE_ID

# 4. Deploy
git push origin main  # Auto-deploys!
```

## 🐛 Troubleshooting

| Issue | Fix |
|-------|-----|
| Hive adapters missing | `flutter pub run build_runner build` |
| Blank web page | Clear cache, check F12 console |
| Build fails | `flutter clean && flutter pub get` |
| Provider not updating | Ensure `notifyListeners()` called |
| GitHub Actions failing | Check branch name is `main` |

## 📊 App Architecture

```
User Action → Dialog Popup
    ↓
User enters data
    ↓
Dialog calls Provider method
    ↓
Provider saves to Hive
    ↓
Provider calls notifyListeners()
    ↓
Consumer widgets rebuild
    ↓
UI shows updated data
```

## 💡 Key Design Decisions

✅ **Provider over Riverpod** - Simpler for this scale  
✅ **Hive over SQLite** - Faster, simpler, no schema  
✅ **Material Design 3** - Modern, consistent UI  
✅ **Clean Architecture** - Maintainable, scalable  
✅ **Dialog popups** - Non-blocking UX flow  

## 🎨 Color Palette

```
Primary:    #6366F1 (Indigo)
Secondary:  #8B5CF6 (Purple)
Success:    #10B981 (Green)
Warning:    #F59E0B (Amber)
Error:      #EF4444 (Red)
Background: #FAFAFA (Light Gray)
Surface:    #FFFFFF (White)
Text:       #1F2937 (Dark Gray)
```

## 📝 File Naming Convention

```
services/      - hive_service.dart, seed_data_provider.dart
models/        - meal.dart, ingredient.dart
providers/     - meal_provider.dart, shopping_provider.dart
widgets/       - meal_logging_dialog.dart
screens/       - dashboard_screen.dart
```

## 🔗 Important URLs

- GitHub: https://github.com/USER/calworries
- Netlify: https://app.netlify.com/sites/YOUR_SITE
- Flutter Docs: https://flutter.dev/docs
- Hive Docs: https://docs.hivedb.dev

## ⚙️ pubspec.yaml (Key Dependencies)

```yaml
provider: ^6.4.0              # State management
hive: ^2.2.3                  # Database
hive_flutter: ^1.1.0          # Flutter DB integration
fl_chart: ^0.65.0             # Charts
intl: ^0.19.0                 # Date/locale
equatable: ^2.0.5             # Value equality
uuid: ^4.0.0                  # ID generation
```

## 📋 Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] Netlify account created
- [ ] Site connected to GitHub
- [ ] NETLIFY_AUTH_TOKEN added to secrets
- [ ] NETLIFY_SITE_ID added to secrets
- [ ] GitHub Actions workflows visible
- [ ] Build successful on first push
- [ ] Netlify deployment complete
- [ ] App accessible at netlify URL

## 🎯 Feature Checklist

- [x] Meal logging with dialog
- [x] Ingredient multi-select
- [x] Health rating slider
- [x] Grocery suggestions popup
- [x] Shopping list with toggle
- [x] Purchase tracking form
- [x] Dashboard overview
- [x] Analytics with charts
- [x] Monthly spending summary
- [x] Hive persistence
- [x] GitHub Actions CI/CD
- [x] Netlify deployment

## 🚨 Critical Files (Don't Delete!)

```
lib/main.dart                              # App entry point
lib/core/services/hive_service.dart        # Database setup
.github/workflows/flutter_ci_cd.yml        # CI/CD pipeline
netlify.toml                               # Netlify config
pubspec.yaml                               # Dependencies
```

## 🔐 Security Notes

✅ No API keys hardcoded  
✅ No sensitive data in code  
✅ Secrets stored in GitHub  
✅ Hive data encrypted option available  
✅ HTTPS on Netlify (auto)  

## 📞 Quick Support

- **Hive Issue?** → Check adapter generation
- **UI Not Updating?** → Check notifyListeners()
- **Build Fails?** → Run flutter clean
- **Deployment Issue?** → Check GitHub Actions logs
- **Still Stuck?** → Check SETUP_GUIDE.md

---

**Pin this for quick reference! 📌**

*Last updated: Flutter 3.16.0*
