# Calworries - Fitness & Grocery Management App

A comprehensive Flutter application combining fitness calorie logging, intelligent grocery suggestions, shopping list management, and spending tracking.

## Features

### 📊 Meal Logging & Tracking
- Log meals with calorie counts
- Categorize meals (Breakfast, Lunch, Dinner, Snack, Drink)
- Tag ingredients used
- Health rating with slider (Poor to Excellent)
- Add optional notes
- View daily/weekly calorie summaries

### 🛒 Smart Grocery Suggestions
- Automatic suggestions based on frequently used ingredients
- Stock prediction ("May run out today")
- One-tap addition to shopping list
- Usage frequency tracking

### 📋 Shopping List Manager
- Add/remove items with quantity tracking
- Mark items as purchased
- Persistent storage
- Quick categorization

### 💰 Spending Tracker
- Record grocery purchases with prices
- Category-wise spending breakdown
- Monthly/weekly spending analytics
- Historical purchase tracking

### 📈 Analytics Dashboard
- Daily/weekly calorie trends
- Most used ingredients chart
- Spending reports by category
- Health ratio analysis

## Architecture

```
lib/
├── core/
│   ├── constants/
│   │   └── enums.dart          # App-wide enumerations
│   ├── services/
│   │   ├── hive_service.dart   # Database initialization
│   │   └── seed_data_provider.dart
│   └── theme/
│       └── app_theme.dart      # Centralized styling
├── features/
│   ├── meals/
│   │   ├── data/
│   │   │   ├── datasources/    # Local storage logic
│   │   │   └── models/         # Meal, Ingredient models
│   │   ├── domain/             # Business logic layer
│   │   └── presentation/       # UI widgets & screens
│   ├── shopping/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── models/         # GroceryItem, ShoppingListItem, SpendingRecord
│   │   ├── domain/
│   │   └── presentation/
│   └── analytics/
│       └── presentation/       # Dashboard & charts
├── shared/
│   ├── providers/              # State management (Provider pattern)
│   └── widgets/                # Reusable UI components
└── main.dart
```

## Tech Stack

- **State Management**: Provider 6.4.0
- **Local Storage**: Hive 2.2.3
- **Charts**: FL Chart 0.65.0
- **Utilities**: Equatable, UUID, Intl
- **UI/UX**: Material Design 3

## Setup Instructions

### Prerequisites
- Flutter 3.16.0 or higher
- Dart 3.0.0 or higher
- Git

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/calworries.git
   cd calworries
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Web Build

```bash
flutter build web --release
```

The web build will be available in `build/web/`

### Android Build

```bash
flutter build apk --release
```

## Project Structure

### Models

**Meal**
- id, name, calories
- mealCategory (enum)
- ingredients (List<Ingredient>)
- healthRating (enum)
- notes, createdAt

**Ingredient**
- id, name, quantity, unit
- lastUsed, usageCount

**GroceryItem**
- id, name, quantity, unit
- category, lastPurchased
- estimatedDaysToEmpty, usageFrequency

**ShoppingListItem**
- id, groceryItemId, itemName
- quantity, unit, isPurchased
- addedAt

**SpendingRecord**
- id, itemName, quantity, unit
- price, category
- purchasedAt

### Providers

**MealProvider**
- Load/save meals
- Calculate daily/weekly calories
- Track ingredient usage
- Get most used ingredients

**ShoppingProvider**
- Manage shopping list
- Track grocery items
- Predict stock levels
- Get frequently used items

**SpendingProvider**
- Record purchases
- Calculate spending by period
- Breakdown by category

## App Flow

1. **User logs meal** → Meal Logging Dialog
2. **Meal saved** → Automatic Grocery Suggestion popup
3. **User adds to shopping list** → Items added to cart
4. **User purchases groceries** → Purchase Tracking Dialog
5. **View analytics** → Dashboard with charts

## CI/CD Pipeline

### GitHub Actions

Two workflows included:

**flutter_ci_cd.yml** - Triggers on push/PR to main/develop
- ✅ Code analysis
- ✅ Unit tests
- ✅ APK build
- 🚀 Netlify deployment (main branch only)

**flutter_release.yml** - Triggers on version tags
- 📦 Builds APK & App Bundle
- 📝 Creates GitHub Release
- ⬆️ Uploads artifacts

### Netlify Deployment

1. **Create Netlify account** - https://netlify.com
2. **Connect GitHub repository**
3. **Set environment variables**:
   ```
   NETLIFY_AUTH_TOKEN=your_token
   NETLIFY_SITE_ID=your_site_id
   ```
4. **Auto-deploys on push to main**

## Setup GitHub Actions & Netlify

### Step 1: GitHub Secrets
1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Add these secrets:
   ```
   NETLIFY_AUTH_TOKEN   # Generate at Netlify → User → Applications
   NETLIFY_SITE_ID      # Found in Netlify site settings
   ```

### Step 2: Netlify Setup
1. Go to https://netlify.com and sign up
2. Click "Add new site" → "Import an existing project"
3. Connect your GitHub repository
4. Build settings:
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`
5. Deploy!

### Step 3: GitHub Actions
Workflows automatically trigger on:
- **Push to main/develop** → CI/CD pipeline
- **Tag push (v*.*.*)** → Release workflow
- **Pull requests** → Analysis & tests

## Seed Data

The app includes dummy data for testing:
- 3 sample meals with ingredients
- 5 grocery items with usage patterns
- 3 spending records

Auto-seeds on first run.

## Best Practices Implemented

✅ **Clean Architecture** - Separation of concerns  
✅ **Provider Pattern** - Simple state management  
✅ **Immutable Models** - Using Equatable  
✅ **Responsive Design** - Works on all screen sizes  
✅ **Error Handling** - Try-catch in providers  
✅ **Code Reusability** - Shared widgets  
✅ **Type Safety** - Null safety enabled  
✅ **Production Ready** - Minimal comments, clean code  

## Future Enhancements

- Cloud sync with Firebase
- Barcode scanning for groceries
- Nutrition analytics (macro tracking)
- Recipe suggestions
- Multi-user household support
- Push notifications for stock alerts
- Export reports as PDF

## Troubleshooting

**Hive boxes not opening?**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build
```

**Web build showing blank page?**
- Clear browser cache
- Check console for errors

**Provider not updating?**
- Ensure `notifyListeners()` called in provider

## License

MIT License

## Support

📧 For questions: support@calworries.app  
🐛 Report bugs: GitHub Issues
