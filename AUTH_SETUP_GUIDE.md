# GitHub OAuth Authentication Setup Guide

This guide walks you through setting up GitHub OAuth authentication for LucidClip.

## Prerequisites

- Supabase account and project
- GitHub account
- Flutter development environment

## Step 1: Supabase Project Setup

1. **Create a Supabase Project** (if you haven't already)
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note down your project URL and anon key

2. **Configure GitHub OAuth Provider**
   - In your Supabase dashboard, navigate to: **Authentication → Providers**
   - Find **GitHub** in the list of providers
   - Toggle it to **Enabled**

## Step 2: GitHub OAuth App Setup

1. **Create a GitHub OAuth App**
   - Go to [GitHub Developer Settings](https://github.com/settings/developers)
   - Click **New OAuth App**
   - Fill in the details:
     - **Application name**: LucidClip
     - **Homepage URL**: `https://your-app-homepage.com` (or your Supabase project URL)
     - **Authorization callback URL**: `https://[YOUR-PROJECT-ID].supabase.co/auth/v1/callback`
       - Replace `[YOUR-PROJECT-ID]` with your Supabase project ID
   - Click **Register application**

2. **Get OAuth Credentials**
   - After creating the app, you'll see your **Client ID**
   - Click **Generate a new client secret** to get your **Client Secret**
   - Copy both values - you'll need them next

3. **Configure in Supabase**
   - Go back to Supabase: **Authentication → Providers → GitHub**
   - Enter your **GitHub Client ID**
   - Enter your **GitHub Client Secret**
   - Click **Save**

## Step 3: Configure Redirect URLs

1. **Add Redirect URLs in Supabase**
   - In Supabase dashboard, go to: **Authentication → URL Configuration**
   - Under **Redirect URLs**, add:
     - `lucidclip://auth-callback` (for desktop deep linking)
     - Any other URLs your app might use
   - Click **Save**

## Step 4: Environment Configuration

1. **Create `.env` file**
   - Copy `.env.example` to `.env` in the project root
   ```bash
   cp .env.example .env
   ```

2. **Fill in your credentials**
   ```env
   SUPABASE_PROJECT_URL=https://[YOUR-PROJECT-ID].supabase.co
   SUPABASE_ANON_KEY=your_supabase_anon_key_here
   SUPABASE_PROJECT_ID=your_project_id
   SUPABASE_TOKEN=your_token
   SUPABASE_API_KEY=your_api_key
   FIREBASE_API_KEY=your_firebase_api_key_here
   GITHUB_CLIENT_ID=your_github_oauth_client_id
   GITHUB_CLIENT_SECRET=your_github_oauth_client_secret
   ```

   **Where to find these values:**
   - `SUPABASE_PROJECT_URL`: Supabase Project Settings → API → Project URL
   - `SUPABASE_ANON_KEY`: Supabase Project Settings → API → anon public key
   - `SUPABASE_PROJECT_ID`: Extract from your project URL (the subdomain)
   - GitHub credentials: From your GitHub OAuth app settings

## Step 5: Generate Required Code

Run the build runner to generate necessary code files:

```bash
# Using melos (recommended)
melos run generate-files

# Or directly
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `lib/features/auth/data/models/user_model.g.dart`
- `lib/core/routes/app_routes.gr.dart`
- `lib/core/di/injection.config.dart`

## Step 6: Platform-Specific Setup

### macOS

The deep link configuration is already added to `macos/Runner/Info.plist`. No additional setup needed.

### Windows

Deep link handling on Windows works through the `url_launcher` package. Registry entries are typically configured during installation.

For development testing:
1. The app should handle the `lucidclip://` URL scheme
2. Windows will prompt to open the app when this scheme is triggered

## Step 7: Test the Authentication Flow

1. **Run the app**
   ```bash
   flutter run -d macos  # or -d windows
   ```

2. **Test sign in**
   - The app will show the login screen on first launch
   - Click "Sign in with GitHub"
   - A browser window will open for GitHub authentication
   - Authorize the app
   - You should be redirected back to the app
   - The app should now show the main screen with your authenticated session

3. **Test persistence**
   - Close and reopen the app
   - You should remain signed in

4. **Test sign out**
   - Navigate to Settings
   - Find the sign out option (you may need to add this to the UI)
   - Click sign out
   - You should be returned to the login screen

## Troubleshooting

### Issue: OAuth redirect not working

**Solution:**
- Verify the callback URL in GitHub matches exactly: `https://[YOUR-PROJECT-ID].supabase.co/auth/v1/callback`
- Check that `lucidclip://auth-callback` is added to Supabase redirect URLs
- Ensure Info.plist (macOS) has the correct URL scheme

### Issue: "Invalid client" error

**Solution:**
- Double-check your GitHub Client ID and Client Secret in Supabase
- Verify they match your GitHub OAuth app credentials
- Ensure there are no extra spaces or characters

### Issue: Deep link not opening the app

**macOS Solution:**
- Verify `CFBundleURLSchemes` in Info.plist contains `lucidclip`
- Restart the app after Info.plist changes
- Test the deep link manually: `open lucidclip://auth-callback`

**Windows Solution:**
- Verify the `url_launcher` package is properly configured
- Check Windows registry for the `lucidclip` protocol handler
- May require app reinstallation to register protocol

### Issue: User not persisting after restart

**Solution:**
- Check that Supabase session is being saved properly
- Verify FlutterSecureStorage permissions on your platform
- Check console logs for any storage errors
- Ensure `SecureStorageService` is properly initialized

### Issue: "Network error" during OAuth

**Solution:**
- Check internet connection
- Verify Supabase project is active and accessible
- Check Supabase project status dashboard
- Try again after a few moments

## Security Best Practices

1. **Never commit `.env` file**
   - `.env` is already in `.gitignore`
   - Always use `.env.example` as a template

2. **Rotate credentials regularly**
   - Regenerate GitHub OAuth secrets periodically
   - Update in Supabase when you do

3. **Use environment-specific configs**
   - Different credentials for development, staging, production
   - Use Flutter flavors for environment management

4. **Secure storage**
   - User tokens are automatically stored in FlutterSecureStorage
   - Never log or expose tokens in production

## Additional Resources

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [GitHub OAuth Documentation](https://docs.github.com/en/developers/apps/building-oauth-apps)
- [Flutter Deep Linking](https://docs.flutter.dev/development/ui/navigation/deep-linking)
- [FlutterSecureStorage](https://pub.dev/packages/flutter_secure_storage)

## Next Steps

After successful authentication setup:

1. **Implement sign out UI**
   - Add a sign out button in settings
   - Consider adding user profile display

2. **Handle auth errors gracefully**
   - Add user-friendly error messages
   - Implement retry mechanisms

3. **Add loading states**
   - Show progress during OAuth flow
   - Handle timeout scenarios

4. **Test on all platforms**
   - Verify on macOS
   - Verify on Windows
   - Test different OAuth scenarios

5. **Monitor authentication**
   - Use Supabase dashboard to monitor sign-ins
   - Track OAuth failures
   - Monitor session lifetimes
