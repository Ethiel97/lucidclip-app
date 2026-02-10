/// Example: Integrating Observability into a Cubit
///
/// This file demonstrates best practices for adding Sentry observability
/// to a Flutter Cubit following LucidClip's patterns.
///
/// NOTE: This file is for documentation purposes only and contains
/// pseudo-code examples. The actual types may need to be adjusted.

import 'dart:async';

// ignore_for_file: unused_element, unreachable_from_main

// Example: Enhanced BillingCubit with Observability
//
// This shows how to add comprehensive error tracking and breadcrumbs
// to an existing cubit without changing its core logic.

class _BillingCubitExample {
  Future<void> getCustomerPortal() async {
    // Assume state management code here...
    
    // ✅ Add breadcrumb when starting the operation
    // await Observability.breadcrumb(
    //   'Fetching customer portal',
    //   category: 'billing',
    //   level: 'info',
    // );

    try {
      // final portal = await billingRepository.getCustomerPortalUrl();

      // ✅ Add success breadcrumb with safe metadata
      // await Observability.breadcrumb(
      //   'Customer portal fetched successfully',
      //   category: 'billing',
      //   level: 'info',
      // );

    } catch (e, st) {
      // ✅ Capture exception with context
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {
      //     'action': 'get_customer_portal',
      //     'feature': 'billing',
      //   },
      // );

      // ✅ Add error breadcrumb
      // await Observability.breadcrumb(
      //   'Failed to fetch customer portal',
      //   category: 'billing',
      //   level: 'error',
      // );
    }
  }

  Future<void> startCheckout({required String productId}) async {
    // ✅ Add breadcrumb with safe metadata
    // await Observability.breadcrumb(
    //   'Starting checkout',
    //   category: 'billing',
    //   data: {
    //     'action': 'start_checkout',
    //   },
    //   level: 'info',
    // );

    try {
      // final session = await billingRepository.startProCheckout(productId);

      // ✅ Success breadcrumb
      // await Observability.breadcrumb(
      //   'Checkout started successfully',
      //   category: 'billing',
      //   level: 'info',
      // );

    } catch (e, st) {
      // ✅ Capture exception with full context
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {
      //     'action': 'start_checkout',
      //     'feature': 'billing',
      //   },
      // );

      // ✅ Error message for critical issues
      // await Observability.message(
      //   'Checkout initiation failed',
      //   level: 'error',
      // );
    }
  }
}

// Example: ClipboardCubit with Observability
//
// This demonstrates privacy-safe clipboard tracking using only metadata.

class _ClipboardCubitExample {
  Future<void> captureClipboardItem() async {
    // ✅ Add breadcrumb for user action
    // await Observability.breadcrumb(
    //   'User triggered clipboard capture',
    //   category: 'clipboard',
    //   data: {
    //     'action': 'capture_item',
    //     'item_count': state.items.length,
    //   },
    //   level: 'info',
    // );

    try {
      // final item = await _repository.captureCurrentClipboard();

      // ✅ PRIVACY: Only log metadata, NEVER the actual content
      // await Observability.breadcrumb(
      //   'Clipboard item captured',
      //   category: 'clipboard',
      //   data: {
      //     'content_type': item.type.name,
      //     'content_length': item.content.length, // ✅ Length is safe
      //     'source': 'keyboard_shortcut',
      //     // ❌ NEVER: 'content': item.content
      //   },
      //   level: 'info',
      // );

    } catch (e, st) {
      // ✅ Capture exception with context
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {
      //     'action': 'clipboard_capture',
      //     'item_count': state.items.length,
      //   },
      // );
    }
  }

  Future<void> deleteItem(String itemId) async {
    // ✅ Breadcrumb for destructive action
    // await Observability.breadcrumb(
    //   'Deleting clipboard item',
    //   category: 'clipboard',
    //   data: {'action': 'delete_item'},
    //   level: 'info',
    // );

    try {
      // await _repository.deleteItem(itemId);

      // await Observability.breadcrumb(
      //   'Clipboard item deleted',
      //   category: 'clipboard',
      //   level: 'info',
      // );

    } catch (e, st) {
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {'action': 'delete_item'},
      // );

      // ✅ Non-critical error, just a warning message
      // await Observability.message(
      //   'Failed to delete clipboard item',
      //   level: 'warning',
      // );
    }
  }
}

// Example: AuthCubit with User Context
//
// Shows how to set/clear user context on auth state changes.

class _AuthCubitExample {
  Future<void> signIn(String email, String password) async {
    // ✅ Breadcrumb for auth action (no credentials!)
    // await Observability.breadcrumb(
    //   'User attempting sign in',
    //   category: 'auth',
    //   level: 'info',
    // );

    try {
      // final user = await _repository.signIn(email, password);

      // ✅ Set user context on successful auth
      // await Observability.setUser(user.id);

      // ✅ Add tag for subscription tier
      // if (user.isPro) {
      //   await Observability.setTag('subscription_tier', 'pro');
      // }

      // await Observability.breadcrumb(
      //   'User signed in successfully',
      //   category: 'auth',
      //   level: 'info',
      // );

    } catch (e, st) {
      // ✅ Auth errors are important, capture with context
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {'action': 'sign_in'},
      // );

      // await Observability.message(
      //   'Sign in failed',
      //   level: 'warning',
      // );
    }
  }

  Future<void> signOut() async {
    // ✅ Breadcrumb for sign out
    // await Observability.breadcrumb(
    //   'User signing out',
    //   category: 'auth',
    //   level: 'info',
    // );

    try {
      // await _repository.signOut();

      // ✅ Clear user context on sign out
      // await Observability.clearUser();

    } catch (e, st) {
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {'action': 'sign_out'},
      // );
    }
  }
}

// Example: Repository with Network Tracking
//
// Shows how to track HTTP requests and responses.

class _ApiRepositoryExample {
  Future<void> fetchUser(String userId) async {
    // ✅ Breadcrumb for network request
    // await Observability.breadcrumb(
    //   'Fetching user data',
    //   category: 'http',
    //   data: {
    //     'action': 'fetch_user',
    //   },
    //   level: 'info',
    // );

    try {
      // final response = await _dio.get('/users/$userId');

      // ✅ Success breadcrumb
      // await Observability.breadcrumb(
      //   'User data fetched',
      //   category: 'http',
      //   level: 'info',
      // );

      // return User.fromJson(response.data);
    } catch (e, st) {
      // ✅ Capture network errors with details
      // await Observability.captureException(
      //   e,
      //   stackTrace: st,
      //   hint: {
      //     'action': 'fetch_user',
      //     'category': 'network',
      //   },
      // );

      rethrow;
    }
  }
}

// Best Practices Summary:
//
// ✅ DO:
// - Add breadcrumbs for user actions and important operations
// - Capture exceptions in catch blocks with context
// - Use metadata (length, type, count) instead of actual data
// - Set user context on login, clear on logout
// - Add tags for filtering (subscription tier, platform, etc.)
// - Use appropriate log levels (debug/info/warning/error/fatal)
//
// ❌ DON'T:
// - Log clipboard contents or any user-entered text
// - Include PII (emails, names, addresses) without consent
// - Log passwords, tokens, or API keys
// - Add breadcrumbs for every single state change
// - Capture non-critical exceptions (use warning messages instead)
// - Use custom context keys without adding them to the allowlist
