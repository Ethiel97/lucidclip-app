# Share Feature Implementation

## Changes Made

### 1. Share Service Infrastructure
Created a new share service following the pattern used for other utility services:

- **`lib/core/services/share_service/share_service.dart`**: Abstract interface defining the contract for share implementations
- **`lib/core/services/share_service/share_plus_service.dart`**: Implementation using the `share_plus` package (already in dependencies)
- **`lib/core/services/share_service/share.dart`**: Facade providing a singleton entry point for sharing
- **`lib/core/services/share_service/share_module.dart`**: Module exports

### 2. Context Menu Integration
Added share functionality to the clipboard context menu:

- Added `share` to the `ClipboardMenuAction` enum
- Added share menu item in primary actions (visible for all item types except `unknown`)
- Implemented `_handleShare()` method that determines what to share based on item type

### 3. Share Logic by Item Type
The implementation decides what can be shared based on item type:

- **Text items**: Share as plain text
- **URL items**: Share as URL
- **File items**: Share file using file path
- **Image items**: Share image (converts bytes to temporary file)
- **HTML items**: Share as text
- **Unknown items**: Not shareable (share option hidden)

### 4. Analytics Tracking
Added `shareUsed` event to track share usage with content type parameter

### 5. Service Registration
Initialized Share facade in `bootstrap.dart` following the same pattern as Analytics

## Next Steps (Code Generation Required)

After these changes, you need to run code generation to register the ShareService with the DI container:

```bash
# Using melos (recommended)
melos run generate-files

# Or directly with dart
fvm dart run build_runner build --delete-conflicting-outputs
```

This will update `lib/core/di/injection.config.dart` to include the SharePlusService registration.

## Testing

1. Build the app after running code generation
2. Right-click on a clipboard item
3. Verify "Share" option appears for text, URL, file, image, and HTML items
4. Verify "Share" option does NOT appear for unknown items
5. Click "Share" and verify the native share dialog appears
6. Verify analytics event is tracked
