#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
APP_NAME="LucidClip"
CERT_ID="Developer ID Application: Ethiel ADIASSA (8B29HJY4QM)"
NOTARY_PROFILE="AC_LUCIDCLIP"

# URL publique où le DMG sera accessible (R2 + domaine)
DOWNLOAD_PREFIX="https://downloads.lucidclip.app/macos/"

# Chemins
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_APP="$PROJECT_ROOT/build/macos/Build/Products/Release-production/${APP_NAME}.app"
UPDATES_REPO="$HOME/Development/projects/lucidclip-updates"   # ajuste
UPDATES_MACOS_DIR="$UPDATES_REPO/macos"

# Sparkle (ajuste vers ton dossier Sparkle)
SPARKLE_BIN="$HOME/Tools/Sparkle/bin"

# ====== VERSION ======
VERSION=$(ruby -e 'puts File.read("'"$PROJECT_ROOT/pubspec.yaml"'")[/version:\s*([0-9]+\.[0-9]+\.[0-9]+)/,1]')
if [[ -z "${VERSION}" ]]; then
  echo "Impossible de lire la version depuis pubspec.yaml"
  exit 1
fi
DMG_NAME="${APP_NAME}-v${VERSION}.dmg"
DMG_PATH="$PROJECT_ROOT/$DMG_NAME"

echo "==> Releasing ${APP_NAME} v${VERSION}"
echo "==> DMG: ${DMG_PATH}"

# ====== 1) BUILD ======
cd "$PROJECT_ROOT"
flutter clean
flutter pub get
flutter build macos --release --flavor production -t lib/main_production.dart --dart-define-from-file=.env

# ====== 2) SIGN & NOTARIZE APP (The Missing Step) ======
echo "==> Signing .app"
# Note: Added --entitlements. Ensure you have this file (standard in Flutter macos/Runner/).
# If you don't have it, remove the flag, but Hardened Runtime usually requires it.
ENTITLEMENTS="$PROJECT_ROOT/macos/Runner/Release.entitlements"

codesign --deep --force --options runtime \
  -d --entitlements "$ENTITLEMENTS" \
  --sign "$CERT_ID" \
  "$BUILD_APP"

codesign --verify --deep --strict --verbose=2 "$BUILD_APP"

echo "==> Zipping App for Notarization"
ZIP_PATH="$PROJECT_ROOT/build/macos/LucidClip.zip"
ditto -c -k --keepParent "$BUILD_APP" "$ZIP_PATH"

echo "==> Notarizing APP (Step 1/2)"
xcrun notarytool submit "$ZIP_PATH" --keychain-profile "$NOTARY_PROFILE" --wait

echo "==> Stapling Ticket to APP"
xcrun stapler staple "$BUILD_APP"
# Now $BUILD_APP has the ticket inside it!

# ====== 3) CREATE DMG (using the STAPLED app) ======
echo "==> Creating DMG"

# (Optional: Use the staging folder method discussed previously to fix the icon issue)
# For brevity, using your original simple command here:
create-dmg \
  --background "$PROJECT_ROOT/assets/installer/macos/dmg_background.tiff" \
  --volname "${APP_NAME} Installer" \
  --volicon "$PROJECT_ROOT/assets/installer/macos/logo.icns" \
  --window-size 800 500 \
  --window-pos 200 120 \
  --icon-size 128 \
  --icon "${APP_NAME}.app" 170 250 \
  --app-drop-link 580 250 \
  --hide-extension "${APP_NAME}.app" \
  --hide-extension "Applications" \
  --no-internet-enable \
  --hdiutil-quiet \
  "$DMG_PATH" \
  "$BUILD_APP"

# ====== 4) NOTARIZE & STAPLE DMG (Step 2/2) ======
echo "==> Notarizing DMG"
xcrun notarytool submit "$DMG_PATH" --keychain-profile "$NOTARY_PROFILE" --wait

echo "==> Stapling Ticket to DMG"
xcrun stapler staple "$DMG_PATH"

# Validate
echo "==> Validating..."
spctl -a -vv "$BUILD_APP"
xcrun stapler validate "$DMG_PATH"

# ====== 5) COPY TO UPDATES REPO ======
echo "==> Copying DMG to updates repo (for appcast generation)"
mkdir -p "$UPDATES_MACOS_DIR"
cp -f "$DMG_PATH" "$UPDATES_MACOS_DIR/$DMG_NAME"

# ====== 6) GENERATE APPCAST ======
echo "==> Generating appcast.xml"
"$SPARKLE_BIN/generate_appcast" \
  --download-url-prefix "$DOWNLOAD_PREFIX" \
  "$UPDATES_MACOS_DIR"

# sanity: ensure signature exists
grep -q "sparkle:edSignature" "$UPDATES_MACOS_DIR/appcast.xml" || {
  echo "appcast.xml généré sans sparkle:edSignature (échec)."
  exit 1
}

echo "==> Done locally."
echo "Next: upload DMG to R2 and push appcast.xml to Pages repo."
