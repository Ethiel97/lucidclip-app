# Auth Feature Implementation Checklist

Use this checklist to complete the setup and validate the authentication feature.

## 🔧 Code Generation (Required)

- [ ] Run code generation command:
  ```bash
  melos run generate-files
  # OR
  dart run build_runner build --delete-conflicting-outputs
  ```

- [ ] Verify generated files were created:
  - [ ] `lib/features/auth/data/models/user_model.g.dart`
  - [ ] `lib/core/routes/app_routes.gr.dart` (updated)
  - [ ] `lib/core/di/injection.config.dart` (updated)

- [ ] Check for build errors after generation:
  ```bash
  flutter analyze
  ```

- [ ] Fix any issues reported by analyzer

## 🌍 Environment Setup

- [ ] Copy `.env.example` to `.env`:
  ```bash
  cp .env.example .env
  ```

- [ ] Create Supabase project (if not already done)
  - [ ] Note down Project URL
  - [ ] Note down Anon Key
  - [ ] Note down Project ID

- [ ] Create GitHub OAuth App:
  - [ ] Go to GitHub Settings → Developer settings → OAuth Apps
  - [ ] Create new OAuth App
  - [ ] Set Authorization callback URL: `https://[PROJECT-ID].supabase.co/auth/v1/callback`
  - [ ] Copy Client ID
  - [ ] Generate and copy Client Secret

- [ ] Configure GitHub provider in Supabase:
  - [ ] Go to Supabase Dashboard → Authentication → Providers
  - [ ] Enable GitHub provider
  - [ ] Enter GitHub Client ID
  - [ ] Enter GitHub Client Secret
  - [ ] Save configuration

- [ ] Add redirect URL in Supabase:
  - [ ] Go to Authentication → URL Configuration
  - [ ] Add `lucidclip://auth-callback` to Redirect URLs
  - [ ] Save configuration

- [ ] Fill in `.env` file with your values:
  - [ ] `SUPABASE_PROJECT_URL`
  - [ ] `SUPABASE_ANON_KEY`
  - [ ] `SUPABASE_PROJECT_ID`
  - [ ] `GITHUB_CLIENT_ID`
  - [ ] `GITHUB_CLIENT_SECRET`
  - [ ] Other required environment variables

## 🧪 Testing - Local Development

### Build and Run

- [ ] Clean and rebuild the project:
  ```bash
  flutter clean
  flutter pub get
  melos run generate-files
  ```

- [ ] Run the app on macOS:
  ```bash
  flutter run -d macos
  ```

- [ ] Run the app on Windows:
  ```bash
  flutter run -d windows
  ```

### Authentication Flow

- [ ] **First Launch**:
  - [ ] App shows login screen
  - [ ] Login screen has proper branding
  - [ ] "Sign in with GitHub" button is visible

- [ ] **Sign In Process**:
  - [ ] Click "Sign in with GitHub"
  - [ ] Loading indicator appears
  - [ ] Browser/webview opens with GitHub OAuth
  - [ ] Authenticate with GitHub account
  - [ ] App receives callback
  - [ ] User is redirected to main app screen
  - [ ] No errors in console

- [ ] **Session Persistence**:
  - [ ] Close the app completely
  - [ ] Reopen the app
  - [ ] App shows main screen (not login screen)
  - [ ] User remains authenticated
  - [ ] User data is still available

- [ ] **Sign Out**:
  - [ ] Navigate to Settings (or wherever sign out is implemented)
  - [ ] Click sign out
  - [ ] App navigates to login screen
  - [ ] Session is cleared
  - [ ] Reopen app shows login screen again

### Error Scenarios

- [ ] **Cancelled OAuth**:
  - [ ] Click "Sign in with GitHub"
  - [ ] Close browser/cancel OAuth
  - [ ] App shows appropriate error message
  - [ ] User can try again

- [ ] **Network Error**:
  - [ ] Disconnect internet
  - [ ] Try to sign in
  - [ ] App shows network error message
  - [ ] Reconnect and retry works

- [ ] **Invalid Credentials**:
  - [ ] Test with invalid Supabase credentials in `.env`
  - [ ] App shows appropriate error
  - [ ] Doesn't crash

### Settings Integration

- [ ] **With Authentication**:
  - [ ] Sign in with GitHub
  - [ ] Navigate to Settings
  - [ ] Change a setting (e.g., theme)
  - [ ] Verify setting is saved
  - [ ] Close and reopen app
  - [ ] Setting persists

- [ ] **Without Authentication**:
  - [ ] Sign out (or fresh install)
  - [ ] Use app in guest mode
  - [ ] Change settings
  - [ ] Settings work locally
  - [ ] No remote sync attempted

### Platform-Specific

- [ ] **macOS Deep Link**:
  - [ ] Test OAuth callback works
  - [ ] App opens from deep link
  - [ ] No issues with URL scheme

- [ ] **Windows Deep Link**:
  - [ ] Test OAuth callback works
  - [ ] App receives callback properly
  - [ ] URL launcher handles scheme correctly

## 🧪 Testing - Unit Tests

- [ ] Run auth cubit tests:
  ```bash
  flutter test test/features/auth/presentation/cubit/auth_cubit_test.dart
  ```

- [ ] All tests pass
- [ ] No warnings or errors

- [ ] Run all tests:
  ```bash
  flutter test
  ```

- [ ] All existing tests still pass
- [ ] No regressions introduced

## 📊 Code Quality

- [ ] Run analyzer:
  ```bash
  flutter analyze
  ```
  - [ ] No errors
  - [ ] No warnings (or acceptable warnings documented)

- [ ] Run formatter:
  ```bash
  dart format . -l 80
  ```
  - [ ] Code is properly formatted

- [ ] Check for unused imports:
  - [ ] No unused imports in auth files
  - [ ] Clean code structure

## 🔍 Code Review Checklist

- [ ] **Architecture**:
  - [ ] Follows clean architecture pattern
  - [ ] Clear separation of concerns
  - [ ] Proper dependency injection

- [ ] **Security**:
  - [ ] No secrets in code
  - [ ] Secure storage properly used
  - [ ] Error messages don't leak sensitive data

- [ ] **Error Handling**:
  - [ ] All auth operations wrapped in try-catch
  - [ ] User-friendly error messages
  - [ ] Proper exception types used

- [ ] **State Management**:
  - [ ] AuthCubit properly manages state
  - [ ] No memory leaks (streams closed properly)
  - [ ] State updates are logical

- [ ] **UI/UX**:
  - [ ] Login screen is intuitive
  - [ ] Loading states are clear
  - [ ] Error states are helpful
  - [ ] Matches app theme and style

## 📚 Documentation

- [ ] Review AUTH_IMPLEMENTATION.md
- [ ] Review AUTH_SETUP_GUIDE.md
- [ ] Review AUTH_IMPLEMENTATION_SUMMARY.md
- [ ] Update main README.md with auth section (use README_AUTH_UPDATE.md)

## 🚀 CI/CD

- [ ] Review CI_WORKFLOW_NOTES.md
- [ ] Decide on code generation strategy:
  - [ ] Option A: Commit generated files
  - [ ] Option B: Update CI to generate code
  - [ ] Option C: Very Good Workflows handles it

- [ ] If committing generated files:
  ```bash
  git add lib/**/*.g.dart lib/**/*.gr.dart lib/**/injection.config.dart
  git commit -m "chore: add generated files for auth"
  git push
  ```

- [ ] If updating CI:
  - [ ] Add code generation step to workflow
  - [ ] Test CI pipeline
  - [ ] Verify builds succeed

- [ ] Push code and create PR
- [ ] Wait for CI to pass
- [ ] Review CI output for issues

## ✅ Final Validation

- [ ] All checklist items completed
- [ ] App builds successfully
- [ ] All tests pass
- [ ] Code is analyzed and formatted
- [ ] Documentation is complete
- [ ] Ready for code review
- [ ] Ready for merge

## 🎉 Post-Merge

- [ ] Verify merged code on main branch
- [ ] Test on fresh clone
- [ ] Update any related documentation
- [ ] Close related issues
- [ ] Celebrate! 🎊

## 📝 Notes

Use this space to note any issues, workarounds, or special considerations:

```
[Add your notes here]
```

---

**Helpful Commands:**

```bash
# Generate code
melos run generate-files

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format . -l 80

# Clean and rebuild
flutter clean && flutter pub get && melos run generate-files

# Run on macOS
flutter run -d macos

# Run on Windows  
flutter run -d windows
```
