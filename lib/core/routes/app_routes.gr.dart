// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:lucid_clip/app/view/lucid_clip_page.dart' as _i3;
import 'package:lucid_clip/features/auth/presentation/view/login_page.dart'
    as _i2;
import 'package:lucid_clip/features/clipboard/presentation/view/clipboard_page.dart'
    as _i1;
import 'package:lucid_clip/features/clipboard/presentation/view/snippets_page.dart'
    as _i5;
import 'package:lucid_clip/features/settings/presentation/view/settings_page.dart'
    as _i4;

/// generated route for
/// [_i1.ClipboardPage]
class ClipboardRoute extends _i6.PageRouteInfo<void> {
  const ClipboardRoute({List<_i6.PageRouteInfo>? children})
    : super(ClipboardRoute.name, initialChildren: children);

  static const String name = 'ClipboardRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.ClipboardPage();
    },
  );
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginPage();
    },
  );
}

/// generated route for
/// [_i3.LucidClipPage]
class LucidClipRoute extends _i6.PageRouteInfo<void> {
  const LucidClipRoute({List<_i6.PageRouteInfo>? children})
    : super(LucidClipRoute.name, initialChildren: children);

  static const String name = 'LucidClipRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.LucidClipPage();
    },
  );
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute({List<_i6.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SettingsPage();
    },
  );
}

/// generated route for
/// [_i5.SnippetsPage]
class SnippetsRoute extends _i6.PageRouteInfo<void> {
  const SnippetsRoute({List<_i6.PageRouteInfo>? children})
    : super(SnippetsRoute.name, initialChildren: children);

  static const String name = 'SnippetsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.SnippetsPage();
    },
  );
}
