// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:lucid_clip/app/view/lucid_clip_page.dart' as _i4;
import 'package:lucid_clip/features/auth/presentation/view/login_page.dart'
    as _i3;
import 'package:lucid_clip/features/clipboard/presentation/view/clipboard_page.dart'
    as _i1;
import 'package:lucid_clip/features/clipboard/presentation/view/snippets_page.dart'
    as _i7;
import 'package:lucid_clip/features/settings/presentation/view/ignored_apps_page.dart'
    as _i2;
import 'package:lucid_clip/features/settings/presentation/view/settings_page.dart'
    as _i5;
import 'package:lucid_clip/features/settings/presentation/view/settings_router_page.dart'
    as _i6;

/// generated route for
/// [_i1.ClipboardPage]
class ClipboardRoute extends _i8.PageRouteInfo<void> {
  const ClipboardRoute({List<_i8.PageRouteInfo>? children})
    : super(ClipboardRoute.name, initialChildren: children);

  static const String name = 'ClipboardRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.ClipboardPage();
    },
  );
}

/// generated route for
/// [_i2.IgnoredAppsPage]
class IgnoredAppsRoute extends _i8.PageRouteInfo<void> {
  const IgnoredAppsRoute({List<_i8.PageRouteInfo>? children})
    : super(IgnoredAppsRoute.name, initialChildren: children);

  static const String name = 'IgnoredAppsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.IgnoredAppsPage();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginPage();
    },
  );
}

/// generated route for
/// [_i4.LucidClipPage]
class LucidClipRoute extends _i8.PageRouteInfo<void> {
  const LucidClipRoute({List<_i8.PageRouteInfo>? children})
    : super(LucidClipRoute.name, initialChildren: children);

  static const String name = 'LucidClipRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.LucidClipPage();
    },
  );
}

/// generated route for
/// [_i5.SettingsPage]
class SettingsRoute extends _i8.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({
    _i9.Key? key,
    String section = 'usage',
    List<_i8.PageRouteInfo>? children,
  }) : super(
         SettingsRoute.name,
         args: SettingsRouteArgs(key: key, section: section),
         rawQueryParams: {'section': section},
         initialChildren: children,
       );

  static const String name = 'SettingsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SettingsRouteArgs>(
        orElse: () => SettingsRouteArgs(
          section: queryParams.getString('section', 'usage'),
        ),
      );
      return _i5.SettingsPage(key: args.key, section: args.section);
    },
  );
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key, this.section = 'usage'});

  final _i9.Key? key;

  final String section;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key, section: $section}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SettingsRouteArgs) return false;
    return key == other.key && section == other.section;
  }

  @override
  int get hashCode => key.hashCode ^ section.hashCode;
}

/// generated route for
/// [_i6.SettingsRouterPage]
class SettingsRouterRoute extends _i8.PageRouteInfo<void> {
  const SettingsRouterRoute({List<_i8.PageRouteInfo>? children})
    : super(SettingsRouterRoute.name, initialChildren: children);

  static const String name = 'SettingsRouterRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SettingsRouterPage();
    },
  );
}

/// generated route for
/// [_i7.SnippetsPage]
class SnippetsRoute extends _i8.PageRouteInfo<void> {
  const SnippetsRoute({List<_i8.PageRouteInfo>? children})
    : super(SnippetsRoute.name, initialChildren: children);

  static const String name = 'SnippetsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SnippetsPage();
    },
  );
}
