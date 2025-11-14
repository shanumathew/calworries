# GitHub Workflows & Netlify Deployment

## 📋 Overview

Your Calworries project now includes four comprehensive GitHub Actions workflows that handle different aspects of the CI/CD pipeline:

```
Push to GitHub
├─ verify-build.yml          → Code analysis + testing + build verification
├─ flutter-ci-cd.yml         → Full CI/CD pipeline (old - for reference)
├─ netlify-deploy.yml        → Direct Netlify deployment
└─ flutter-release.yml       → Production release builds
```

---

## 🔄 Workflow Details

### 1️⃣ **verify-build.yml** (NEW - Main Build Verification)

**Triggers:** On every push to `main`, `develop`, `master` or pull request

**What it does:**
```
Checkout → Setup Flutter → Get Dependencies → Code Generation
  ↓
Analyze Code → Run Tests → Build Web
  ↓
Upload Artifacts → Success Message
```

**Steps:**
- ✅ Checkout code
- ✅ Setup Flutter 3.16.0
- ✅ Install dependencies (`flutter pub get`)
- ✅ Generate Hive adapters (`dart run build_runner build`)
- ✅ Analyze code (`flutter analyze`)
- ✅ Run tests (`flutter test`)
- ✅ Build web release (`flutter build web --release`)
- ✅ Upload build artifacts (5-day retention)

**Use case:** Verify builds work on every commit, catch errors early

---

### 2️⃣ **netlify-deploy.yml** (NEW - Netlify Deployment)

**Triggers:** On push to `main` or `develop` branches

**What it does:**
```
Checkout → Setup Flutter → Get Dependencies → Code Generation
  ↓
Build Web → Deploy to Netlify → Success Message
```

**Steps:**
- ✅ Checkout code
- ✅ Setup Flutter 3.16.0
- ✅ Install dependencies
- ✅ Generate code
- ✅ Build web optimized
- ✅ Deploy to Netlify
- ✅ Post GitHub comments with deploy preview

**Use case:** Automatically deploy to Netlify on every push to main/develop

**Required Secrets:**
```
NETLIFY_AUTH_TOKEN    → Your Netlify personal access token
NETLIFY_SITE_ID       → Your Netlify site ID
GITHUB_TOKEN          → Auto-provided by GitHub
```

---

### 3️⃣ **flutter-ci-cd.yml** (EXISTING - Full Pipeline)

**Triggers:** On push to `main`, `develop`

**Jobs (in order):**
1. `analyze` - Code analysis
2. `test` - Run tests
3. `build_apk` - Android APK (depends on analyze + test, main branch only)
4. `build_web` - Web build (depends on analyze + test)
5. `deploy_netlify` - Deploy to Netlify (depends on build_web, main branch only)

**Use case:** Comprehensive CI/CD for all platforms (Android + Web)

---

### 4️⃣ **flutter-release.yml** (EXISTING - Release Builds)

**Triggers:** When you push a git tag like `v1.0.0`

**What it does:**
```
Tag pushed (e.g., v1.0.0)
  ↓
Build APK (split per ABI) → Build App Bundle
  ↓
Create GitHub Release → Upload binaries as assets
```

**Use case:** Create production releases with versioning

**How to trigger:**
```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## 📊 Workflow Comparison

| Feature | verify-build | netlify-deploy | flutter-ci-cd | flutter-release |
|---------|--------------|----------------|---------------|-----------------|
| Branches | main, develop, master | main, develop | main, develop | version tags |
| Analyze | ✅ | ✗ | ✅ | ✗ |
| Test | ✅ | ✗ | ✅ | ✗ |
| Build Web | ✅ | ✅ | ✅ | ✗ |
| Build APK | ✗ | ✗ | ✅ | ✅ |
| Deploy Netlify | ✗ | ✅ | ✅ | ✗ |
| Upload Artifacts | ✅ | ✗ | ✅ | ✅ |
| Speed | Fast (4-5 min) | Medium (6-8 min) | Slow (12-15 min) | Medium (8-10 min) |

---

## 🚀 Usage Scenarios

### Scenario 1: Daily Development

```bash
# Work on a feature
git checkout -b feature/new-feature
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# Creates pull request → runs verify-build.yml
# → Tests & analyzes your code
```

**Expected:** ✅ Green checkmark on PR if code is good

---

### Scenario 2: Merge to Main (Deploy to Web)

```bash
# Merge PR to main
git checkout main
git merge feature/new-feature
git push origin main

# Triggers: verify-build.yml + netlify-deploy.yml
# → verify-build.yml: confirms everything works
# → netlify-deploy.yml: deploys to Netlify
```

**Result:** 
- ✅ Code verified
- ✅ Automatically deployed to `https://calworries.netlify.app`
- ✅ GitHub comment shows preview link

---

### Scenario 3: Create Release Version

```bash
# When ready to release
git tag v1.0.0
git push origin v1.0.0

# Triggers: flutter-release.yml
# → Builds APK + App Bundle
# → Creates GitHub Release
# → Uploads binaries as downloadable assets
```

**Result:**
- ✅ GitHub Release created at `github.com/yourusername/calworries/releases/tag/v1.0.0`
- ✅ APK available for download
- ✅ App Bundle available for Google Play Store

---

## 🔐 Security Configuration (netlify.toml)

Enhanced with security headers and caching:

```toml
# Build command with no tree shake for better compatibility
[build]
  command = "flutter build web --release --no-tree-shake-icons"
  publish = "build/web"

# SPA routing - all requests go to index.html
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Security headers for all files
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "SAMEORIGIN"                    # Prevent clickjacking
    X-Content-Type-Options = "nosniff"               # Prevent MIME sniffing
    X-XSS-Protection = "1; mode=block"              # XSS protection
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"
    Content-Security-Policy = "..."                 # CSP configuration

# Cache control for index.html
[[headers]]
  for = "/index.html"
  [headers.values]
    Cache-Control = "no-cache, no-store, must-revalidate"

# Long cache for assets (1 year)
[[headers]]
  for = "/assets/**"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

# Long cache for compiled JS/CSS
[[headers]]
  for = "/**/*.{js,css}"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

---

## 🔧 Setup Instructions

### Step 1: Add GitHub Secrets

```
Go to: GitHub repo → Settings → Secrets and variables → Actions
```

Add these secrets:

| Secret | Value | Where to get |
|--------|-------|-------------|
| NETLIFY_AUTH_TOKEN | Your token | Netlify → User Settings → Applications → New access token |
| NETLIFY_SITE_ID | Your site ID | Netlify → Site Settings → Site information |
| GITHUB_TOKEN | Auto-provided | Already available |

### Step 2: Verify Workflows

```
Go to: GitHub repo → Actions
```

You should see 4 workflows:
- ✅ Verify Build
- ✅ Deploy to Netlify
- ✅ Flutter CI/CD
- ✅ Flutter Build and Release

### Step 3: Configure Netlify

1. Go to `app.netlify.com`
2. Click "Import an existing project"
3. Connect to GitHub
4. Select your repository
5. Build settings already configured in `netlify.toml`
6. Deploy!

### Step 4: Test Everything

```bash
# 1. Push to develop branch
git push origin develop

# 2. Check workflows
# Go to GitHub → Actions → See both workflows run

# 3. Check Netlify
# Go to netlify.com → Your site → Deploys → See deploy preview

# 4. Verify live site
# Visit https://calworries.netlify.app
```

---

## 📈 Recommended Workflow

```
Feature Branch (verify-build.yml runs)
         ↓
    Create PR (tests run)
         ↓
   Code Review ✓
         ↓
 Merge to main (verify-build.yml + netlify-deploy.yml run)
         ↓
Live on https://calworries.netlify.app
         ↓
    (When ready for release)
         ↓
   Push version tag (flutter-release.yml runs)
         ↓
GitHub Release with downloadable APK/AAB
```

---

## 🐛 Troubleshooting

### Workflow doesn't run?

**Check 1:** Is the branch correct? (main, develop, or master)
```bash
git branch -a  # Check current branch
```

**Check 2:** Are secrets configured?
```
GitHub → Settings → Secrets → See NETLIFY_AUTH_TOKEN and NETLIFY_SITE_ID
```

**Check 3:** Push again to trigger
```bash
git push origin main
```

### Build fails in GitHub but works locally?

**Common causes:**
1. Forgot to run `dart run build_runner build`
2. Pubspec.yaml has different versions
3. Floating dependencies

**Solution:**
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release
```

### Deployment to Netlify fails?

**Check:** 
1. `build/web` folder exists locally
2. `netlify.toml` is in root directory
3. Secrets are correct (no typos)

**Reset Netlify connection:**
```
Netlify → Site Settings → General → Disconnect site → Reconnect from GitHub
```

### Artifacts not uploading?

**Verify:**
```bash
flutter build web --release
ls -la build/web/  # Should show index.html
```

---

## 📊 Monitoring

### Check Workflow Status

```
GitHub → Actions → [Workflow Name] → See all runs
```

### View Deployment History

```
Netlify → Deploys → See all deployments with commit info
```

### Monitor Build Artifacts

```
GitHub → Actions → [Run] → Artifacts → Download build files
```

---

## 🎯 Next Steps

1. ✅ Push to `main` branch
2. ✅ Watch workflows run (GitHub Actions tab)
3. ✅ See live deployment (Netlify URL in workflow output)
4. ✅ Create version tag when ready to release
5. ✅ Download APK from GitHub Releases

---

## 📚 Related Files

- `netlify.toml` - Deployment configuration with security headers
- `.github/workflows/verify-build.yml` - New build verification
- `.github/workflows/netlify-deploy.yml` - New Netlify deployment
- `.github/workflows/flutter-ci-cd.yml` - Existing full pipeline
- `.github/workflows/flutter-release.yml` - Existing release workflow

---

## 💡 Pro Tips

1. **Branch naming:** Use `feature/`, `bugfix/`, `hotfix/` prefixes for clarity
2. **Commit messages:** Use conventional commits: `feat:`, `fix:`, `docs:`, etc.
3. **Release naming:** Use semver: `v1.0.0`, `v1.0.1`, `v1.1.0`, etc.
4. **Monitor artifacts:** Keep 5-day retention to save GitHub space
5. **Test locally first:** Always run `flutter test` before pushing

---

## ✨ What's New

| Component | Change | Benefit |
|-----------|--------|---------|
| verify-build.yml | NEW | Faster feedback on every commit |
| netlify-deploy.yml | NEW | Dedicated deployment workflow |
| netlify.toml | ENHANCED | Security headers + cache config |
| Flutter version | 3.16.0 | Latest stable version |
| Permissions | NEW | Geolocation, camera, microphone disabled for privacy |

---

## 🚀 You're All Set!

Your project now has:
- ✅ Automated testing on every push
- ✅ Automatic deployment to Netlify on main/develop
- ✅ Release automation with GitHub Releases
- ✅ Security headers configured
- ✅ Optimal caching strategy
- ✅ Production-ready CI/CD

**Just push to main and watch it deploy automatically!** 🎉
