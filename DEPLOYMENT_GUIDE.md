# Netlify Deployment Guide

## Manual Deployment

### Build Locally First

```bash
flutter clean
flutter pub get
flutter build web --release
```

Build output: `build/web/`

### Deploy via Netlify Drop

1. Go to https://app.netlify.com/drop
2. Drag and drop `build/web/` folder
3. Your app is live!

## Automated Deployment via GitHub Actions

### Prerequisites

✅ GitHub repository created  
✅ Flutter code pushed to GitHub  
✅ Netlify account created

### Step-by-Step Setup

#### 1. Create Netlify Site

1. Go to https://app.netlify.com
2. Click "Add new site"
3. Choose "Import an existing project"
4. Connect GitHub account
5. Select `calworries` repository
6. Set build settings:
   - **Build command**: `flutter build web --release`
   - **Publish directory**: `build/web`
7. Click "Deploy site"

#### 2. Get Netlify Credentials

**Get NETLIFY_SITE_ID:**
- In Netlify dashboard, go to "Site settings"
- Look for "Site ID" under General section
- Copy it (format: `xxxxx-yyyyy-zzzzz`)

**Get NETLIFY_AUTH_TOKEN:**
- In Netlify, go to "User settings"
- Click "Applications" → "Personal access tokens"
- Click "New access token"
- Name it: `GitHub Actions`
- Copy the token (keep it secret!)

#### 3. Add GitHub Secrets

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add two secrets:

```
NETLIFY_AUTH_TOKEN = [paste your token]
NETLIFY_SITE_ID = [paste your site ID]
```

#### 4. Enable Workflows

1. Go to repository "Actions" tab
2. You should see "Flutter CI/CD" workflow
3. Click "Enable" if needed
4. Workflows are now active!

### How It Works

**On every push to `main` branch:**

```
Your push to GitHub
    ↓
GitHub Actions triggers
    ↓
flutter pub get
flutter build web --release
    ↓
Upload build to Netlify
    ↓
Netlify deploys to production
    ↓
App is live at your URL
```

## Monitor Deployments

### GitHub Actions

1. Go to Actions tab
2. See all workflow runs
3. Click on a run to see logs
4. Check build errors if deployment fails

### Netlify

1. Go to https://app.netlify.com
2. Select your site
3. Go to "Deployments" tab
4. See all deployment history
5. View build logs
6. Rollback if needed

## Custom Domain

1. Go to Site settings → Domain management
2. Click "Add domain"
3. Choose: Connect a custom domain
4. Enter your domain (example.com)
5. Follow DNS instructions
6. Your app is now at your custom domain!

## Environment Variables

### Add to Netlify

1. Site settings → Build & deploy → Environment
2. Click "Edit variables"
3. Add key-value pairs:
   ```
   FLUTTER_ENV = production
   API_URL = https://api.example.com
   ```

### Use in Flutter

```dart
String apiUrl = String.fromEnvironment('API_URL', 
  defaultValue: 'https://localhost');
```

## SSL/HTTPS

✅ Automatically enabled by Netlify  
✅ Free SSL certificate  
✅ Auto-renews

## Performance

### Optimize Web Build

```bash
flutter build web --release --dart-define=FLUTTER_WEB_ENABLE_CANVASKITJS=true
```

### CDN

Netlify automatically uses CDN for:
- JavaScript files
- CSS files
- Images
- Static assets

### Deployment Checks

1. **Link previews** - Every PR gets a preview URL
2. **Analytics** - Track page views, errors
3. **Forms** - Capture form submissions
4. **Functions** - Run serverless functions

## Rollback

If deployment has issues:

1. Go to Netlify Deployments tab
2. Find previous working deployment
3. Click "Publish deploy"
4. Site rolls back instantly

## Troubleshooting

### Build Fails

**Check logs in Netlify:**
- Deployments tab → Click failed deploy → View logs
- Look for error messages
- Common issues:
  - Flutter not installed
  - Missing dependencies
  - Hive adapters not generated

**Fix:**
- Ensure `flutter pub run build_runner build` included
- Check `netlify.toml` has correct build command

### Blank Page After Deploy

- Clear browser cache
- Check browser console (F12) for errors
- Verify `flutter build web` works locally
- Check `index.html` is in build/web

### GitHub Actions Not Running

- Verify branch name is exactly `main` (not `master`)
- Check if workflows are enabled in Actions tab
- Verify `.github/workflows/flutter_ci_cd.yml` exists
- Make sure NETLIFY secrets are set

### Site Doesn't Update

1. Clear Netlify cache: Site settings → Danger zone → Clear cache
2. Force rebuild: Deploys tab → Trigger deploy → Deploy site
3. Clear browser cache (Ctrl+Shift+Delete)

## Advanced: Preview Deploys

Preview deploys on every PR:

1. Go to Site settings → Build & deploy
2. Scroll to "Deploy previews"
3. Enable deploy previews
4. Each PR now gets unique preview URL

## Monitoring & Analytics

### Netlify Analytics

- Site analytics → View traffic
- See where users come from
- Track page performance
- Monitor errors

### Setup Google Analytics (Optional)

1. Add to `web/index.html`:
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```

## Auto-Deployment Checklist

- ✅ Netlify site created
- ✅ GitHub repository connected
- ✅ NETLIFY_AUTH_TOKEN set
- ✅ NETLIFY_SITE_ID set
- ✅ `.github/workflows/flutter_ci_cd.yml` exists
- ✅ Build command correct
- ✅ Publish directory correct
- ✅ Push to `main` branch

## URLs

- **Production**: https://your-site-name.netlify.app
- **Custom domain**: https://example.com
- **PR preview**: https://deploy-preview-123--your-site.netlify.app

## Support

- Netlify Docs: https://docs.netlify.com
- GitHub Actions: https://docs.github.com/en/actions
- Flutter Web: https://flutter.dev/docs/get-started/web

---

**Deployment ready! Push to main and watch it auto-deploy 🚀**
