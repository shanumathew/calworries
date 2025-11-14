# 🚀 Workflows Quick Reference

## At a Glance

```
YOUR ACTION                      WORKFLOW TRIGGERED              RESULT
═══════════════════════════════════════════════════════════════════════
Push to feature branch     →     verify-build.yml          →    Test & analyze
Create/update PR           →     verify-build.yml          →    Check on PR
Merge to main              →     verify-build.yml +        →    Deploy to web
                                 netlify-deploy.yml
Merge to develop           →     verify-build.yml +        →    Deploy preview
                                 netlify-deploy.yml
Push tag (v1.0.0)          →     flutter-release.yml       →    GitHub Release
```

---

## 4 Workflows in Your Project

### 1. **verify-build.yml** ⚡ (FAST)
- **When:** Every push to main/develop/master, all PRs
- **Time:** ~4-5 minutes
- **Does:** Analyzes, tests, builds web
- **Status:** Shows on GitHub PR ✓ or ✗

### 2. **netlify-deploy.yml** 🌐 (MEDIUM)
- **When:** Push to main or develop
- **Time:** ~6-8 minutes
- **Does:** Builds + deploys to Netlify
- **Result:** Live URL in comments

### 3. **flutter-ci-cd.yml** 🔄 (SLOW - Old but kept for reference)
- **When:** Push to main/develop
- **Time:** ~12-15 minutes
- **Does:** Full pipeline (Android + Web + Deploy)
- **Result:** APK artifact + Netlify deploy

### 4. **flutter-release.yml** 📦 (MEDIUM)
- **When:** Push version tag (v1.0.0)
- **Time:** ~8-10 minutes
- **Does:** Builds Android release + Creates GitHub Release
- **Result:** Downloadable APK/AAB

---

## Common Tasks

### 📝 I want to test my changes

```bash
git checkout -b feature/my-feature
# Make changes...
git add .
git commit -m "feat: Add my feature"
git push origin feature/my-feature

# → verify-build.yml runs automatically
# → See results in GitHub PR
```

### 🚀 I want to deploy to production

```bash
git checkout main
git merge feature/my-feature
git push origin main

# → verify-build.yml: Confirms everything works
# → netlify-deploy.yml: Deploys to Netlify
# → Check: https://calworries.netlify.app
```

### 📦 I want to create a release

```bash
# Bump version in pubspec.yaml
# Commit and push
git add pubspec.yaml
git commit -m "chore: Bump version to 1.0.0"
git push origin main

# Create tag
git tag v1.0.0
git push origin v1.0.0

# → flutter-release.yml runs
# → See Release on GitHub
```

### 🔍 I want to see what happened

```
GitHub → Actions → [Workflow Name]
```

---

## Secrets Setup (Do This First!)

```
GitHub → Settings → Secrets and variables → Actions

Add:
  Name: NETLIFY_AUTH_TOKEN
  Value: [Get from netlify.com → User Settings → Applications]

  Name: NETLIFY_SITE_ID
  Value: [Get from netlify.com → Site Settings → Site information]
```

---

## Files to Know

| File | Purpose |
|------|---------|
| `.github/workflows/verify-build.yml` | Build verification |
| `.github/workflows/netlify-deploy.yml` | Netlify deployment |
| `.github/workflows/flutter-ci-cd.yml` | Full CI/CD (reference) |
| `.github/workflows/flutter-release.yml` | Release builds |
| `netlify.toml` | Netlify config + security headers |

---

## Status Checks

### ✅ Green = Good
- Code builds successfully
- Tests pass
- No analysis errors
- Ready to deploy

### ❌ Red = Issue
- Build failed
- Tests failed
- Analysis errors
- Check workflow logs

### 🟡 Yellow = Running
- Still building/testing
- Wait for completion
- Don't merge PRs yet

---

## Workflow Triggers

### Branches
- `main` - Production, auto-deploys
- `develop` - Staging, auto-deploys preview
- `master` - Legacy, still runs verify

### Events
- `push` - Your commits
- `pull_request` - Code review
- `tags` - Version releases

---

## Cache Strategy

```
/index.html           → No cache (always fetch latest)
/assets/*             → Cache 1 year (never changes)
/*.{js,css}           → Cache 1 year (never changes)
/*                    → Security headers (same-origin, no sniff, etc)
```

---

## 🎯 Recommended Flow

```
1. Create branch
   ↓
2. Make changes
   ↓
3. Push branch (verify-build runs)
   ↓
4. Create PR (review & verify-build runs)
   ↓
5. Merge to main (netlify-deploy runs)
   ↓
6. Live! ✨
   ↓
7. When ready: git tag v1.0.0 (flutter-release runs)
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Workflow doesn't run | Check branch name (main/develop/master) |
| Deployment fails | Verify NETLIFY_AUTH_TOKEN and NETLIFY_SITE_ID |
| Build fails locally but works in GitHub | Delete build/ folder, run `flutter clean` |
| Tests fail in GitHub | Run `flutter test` locally first |
| Can't find deployment link | Check workflow logs, look for Netlify URL |

---

## ⚡ Quick Commands

```bash
# See status locally
flutter analyze                  # Check code quality
flutter test                     # Run tests
flutter build web --release      # Build for deployment

# Push and trigger workflows
git push origin main             # Triggers verify + deploy
git tag v1.0.0 && git push --tags  # Triggers release

# Check workflow status
# Open: GitHub → Actions
```

---

## 🎉 Summary

You have:
- ✅ 4 automated workflows
- ✅ Security headers configured
- ✅ Optimal caching strategy
- ✅ Auto-deployment to Netlify
- ✅ Release automation

**Push to main → Automatic deployment! 🚀**

For more details, read: `WORKFLOWS_GUIDE.md`
