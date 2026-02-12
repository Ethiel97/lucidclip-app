import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';

/// A [RouteObserver] that sends screen view events using [Analytics].
///
class NavigatorAnalyticsObserver extends AutoRouteObserver {
  String _adjustName(String routeName) {
    return routeName.replaceAll(RegExp(r'Route$'), '');
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _logScreenView(route.name, previousRoute?.name);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _logScreenView(route.name, previousRoute.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    _logScreenView(previousRoute?.settings.name, route.settings.name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    _logScreenView(route.settings.name, previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    _logScreenView(newRoute?.settings.name, oldRoute?.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    _logScreenView(previousRoute?.settings.name, route.settings.name);
  }

  void _logScreenView(String? newRoute, String? oldRoute) {
    if (newRoute != null) {
      Analytics.track(AnalyticsEvent.screenEntered, {
        'screen_name': _adjustName(newRoute),
      }).unawaited();
    }

    if (oldRoute != null) {
      Analytics.track(AnalyticsEvent.screenExited, {
        'screen_name': _adjustName(oldRoute),
      }).unawaited();
    }
  }
}
