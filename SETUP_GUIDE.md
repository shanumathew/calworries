# Calworries - Complete Setup Guide

## Prerequisites

- Flutter SDK 3.16.0+
- Dart SDK 3.0.0+
- Git
- GitHub Account (for CI/CD)
- Netlify Account (for deployment)

## Installation Steps

### 1. Initial Setup

```bash
# Navigate to project
cd calworries

# Get all dependencies
flutter pub get

# Generate Hive adapters (IMPORTANT!)
flutter pub run build_runner build

# Clean build if needed
flutter pub run build_runner clean
flutter pub run build_runner build
```

### 2. Run Locally

```bash
# Desktop (Windows)
flutter run -d windows

# Web
flutter run -d web --debug

# Mobile (need Android emulator/iOS simulator running)
flutter run
```

### 3. Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## GitHub Setup

### 1. Initialize Git Repository

```bash
git init
git add .
git commit -m "Initial commit: Full Flutter app setup"
git remote add origin https://github.com/YOUR_USERNAME/calworries.git
git branch -M main
git push -u origin main
```

### 2. Add GitHub Secrets

1. Go to your repository
2. Settings → Secrets and variables → Actions
3. Create these secrets:

| Secret Name | Value |
|-------------|-------|
| `NETLIFY_AUTH_TOKEN` | Generate at: https://app.netlify.com/user/applications/personal |
| `NETLIFY_SITE_ID` | Get from: Netlify site settings → Site info |

### 3. How to Get These Secrets

**NETLIFY_AUTH_TOKEN:**
- Go to https://app.netlify.com/user/applications/personal
- Click "New access token"
- Copy the token
- Paste in GitHub Secrets

**NETLIFY_SITE_ID:**
- Create a new site on Netlify
- Go to Site settings → General
- Find "Site ID" and copy it

## Netlify Deployment

### 1. Create Netlify Site

```bash
# Via Netlify CLI (optional)
npm install -g netlify-cli
netlify init
```

Or manually at https://app.netlify.com

### 2. Connect GitHub

1. Create new site on Netlify
2. Choose "Import existing project"
3. Select GitHub
4. Choose calworries repository
5. Build settings:
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`
6. Deploy!

### 3. Auto-Deploy on Push

With the GitHub Actions workflow and secrets set up:
- Every push to `main` → Auto-deploys to Netlify
- PRs → Run tests and analysis

## Workflow Overview

### GitHub Actions Workflows

**flutter_ci_cd.yml** (Auto-triggers):
- On push to `main` or `develop`
- On PR to `main` or `develop`

Steps:
1. Analyze code
2. Run tests
3. Build APK
4. Build Web
5. Deploy to Netlify (main only)

**flutter_release.yml** (Manual):
- Trigger with tag: `git tag v1.0.0 && git push --tags`
- Builds release APK & App Bundle
- Creates GitHub Release

## Development Workflow

### Feature Branch Workflow

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes...

# Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# Create Pull Request on GitHub
# Automatic checks will run
```

### Release Process

```bash
# When ready for release
git tag v1.0.0
git push --tags

# GitHub automatically:
# - Builds APK & App Bundle
# - Creates Release
# - Uploads artifacts
```

## Environment Variables

Create `.env` file (for local development):
```
ANALYTICS_API=https://api.example.com
DEBUG=false
```

Then load in main.dart:
```dart
// dotenv.load();
```

## Troubleshooting

### Build Issues

**"Hive adapters not found"**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build
```

**"flutter: No pubspec.yaml found"**
```bash
# Make sure you're in project root directory
pwd  # Should show: .../calworries
```

### GitHub Actions Issues

**Workflows not running?**
1. Check branch name is `main` (not `master`)
2. Push to `main` branch
3. Check Actions tab for errors

**Netlify deployment failed?**
1. Check NETLIFY_AUTH_TOKEN is valid
2. Check NETLIFY_SITE_ID exists
3. View logs in GitHub Actions

### Web Build Issues

**Blank page after deploy?**
- Clear browser cache (Ctrl+Shift+Delete)
- Check browser console (F12) for errors
- Try different browser

## Project Structure Summary

```
calworries/
├── .github/workflows/           # CI/CD pipelines
│   ├── flutter_ci_cd.yml
│   └── flutter_release.yml
├── lib/
│   ├── core/
│   │   ├── constants/           # Enums
│   │   ├── services/            # Database, seed data
│   │   └── theme/               # Styling
│   ├── features/
│   │   ├── meals/               # Meal feature
│   │   ├── shopping/            # Shopping feature
│   │   └── analytics/           # Dashboard
│   ├── shared/
│   │   ├── providers/           # State management
│   │   └── widgets/             # Reusable widgets
│   └── main.dart
├── test/                        # Unit tests
├── pubspec.yaml                 # Dependencies
├── netlify.toml                 # Netlify config
└── README.md                    # Project docs
```

## Next Steps

1. ✅ Complete setup
2. ✅ Run locally: `flutter run`
3. ✅ Create GitHub repo
4. ✅ Push code
5. ✅ Create Netlify site
6. ✅ Add GitHub secrets
7. ✅ Verify CI/CD workflows
8. 🚀 Start development!

## Useful Commands

```bash
# Analysis
flutter analyze

# Tests
flutter test

# Build
flutter build apk --release
flutter build web --release

# Clean
flutter clean

# Get updates
flutter upgrade
flutter pub upgrade

# Format code
dart format lib/ --line-length=100

# Generate code
flutter pub run build_runner build
```

## Resources

- Flutter: https://flutter.dev
- Provider: https://pub.dev/packages/provider
- Hive: https://docs.hivedb.dev
- Netlify: https://docs.netlify.com
- GitHub Actions: https://docs.github.com/en/actions

---

**For questions, check README.md or open an issue on GitHub**
