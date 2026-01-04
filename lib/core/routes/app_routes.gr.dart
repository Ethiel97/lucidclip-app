// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:lucid_clip/app/view/lucid_clip_page.dart' as _i2;
import 'package:lucid_clip/features/clipboard/presentation/view/clipboard_page.dart'
    as _i1;
import 'package:lucid_clip/features/clipboard/presentation/view/snippets_page.dart'
    as _i4;
import 'package:lucid_clip/features/settings/presentation/view/settings_page.dart'
    as _i3;

/// generated route for
/// [_i1.ClipboardPage]
class ClipboardRoute extends _i5.PageRouteInfo<void> {
  const ClipboardRoute({List<_i5.PageRouteInfo>? children})
    : super(ClipboardRoute.name, initialChildren: children);

  static const String name = 'ClipboardRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.ClipboardPage();
    },
  );
}

/// generated route for
/// [_i2.LucidClipPage]
class LucidClipRoute extends _i5.PageRouteInfo<void> {
  const LucidClipRoute({List<_i5.PageRouteInfo>? children})
    : super(LucidClipRoute.name, initialChildren: children);

  static const String name = 'LucidClipRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.LucidClipPage();
    },
  );
}

/// generated route for
/// [_i3.SettingsPage]
class SettingsRoute extends _i5.PageRouteInfo<void> {
  const SettingsRoute({List<_i5.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SettingsPage();
    },
  );
}

/// generated route for
/// [_i4.SnippetsPage]
class SnippetsRoute extends _i5.PageRouteInfo<void> {
  const SnippetsRoute({List<_i5.PageRouteInfo>? children})
    : super(SnippetsRoute.name, initialChildren: children);

  static const String name = 'SnippetsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.SnippetsPage();
    },
  );
}
