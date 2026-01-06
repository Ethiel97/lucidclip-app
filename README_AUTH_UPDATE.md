# Authentication Feature - README Update

Add the following section to the main README.md:

---

## 🔐 Authentication

LucidClip now supports GitHub OAuth authentication via Supabase, enabling secure cloud synchronization of your clipboard data across devices.

### Features

- **GitHub OAuth Sign-In**: Secure authentication using your GitHub account
- **Session Persistence**: Stay signed in across app restarts
- **Cloud Sync**: Synchronize clipboard history and settings across devices
- **Secure Storage**: User tokens and data encrypted with FlutterSecureStorage
- **Guest Mode**: Use the app without authentication (local storage only)

### Quick Start

1. **Setup Authentication**
   - Follow the [Authentication Setup Guide](AUTH_SETUP_GUIDE.md) for detailed instructions
   - Configure Supabase and GitHub OAuth
   - Set up environment variables

2. **Sign In**
   - Launch the app
   - Click "Sign in with GitHub" on the login screen
   - Authorize the app in your browser
   - You'll be automatically redirected back to the app

3. **Use Cloud Sync**
   - Once authenticated, your clipboard history automatically syncs
   - Settings are synchronized across all your devices
   - Access your clipboard from any device

### Documentation

- [Authentication Implementation](AUTH_IMPLEMENTATION.md) - Technical details and architecture
- [Authentication Setup Guide](AUTH_SETUP_GUIDE.md) - Step-by-step setup instructions
- [Environment Configuration](.env.example) - Environment variables template

### Privacy & Security

- All authentication is handled securely through Supabase
- Tokens are encrypted and stored locally
- You can sign out at any time to clear your session
- Guest mode is available for local-only use without authentication

---

## Alternative: Update Existing Features Section

If there's already a Features section in README.md, add this:

### Authentication & Cloud Sync
- 🔐 **GitHub OAuth**: Secure sign-in with your GitHub account
- ☁️ **Cloud Sync**: Synchronize clipboard across all your devices
- 🔒 **Encrypted Storage**: Secure token storage with FlutterSecureStorage
- 👤 **Guest Mode**: Use locally without an account

---
