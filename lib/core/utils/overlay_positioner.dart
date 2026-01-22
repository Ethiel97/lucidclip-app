import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'dart:ui';

import 'package:screen_retriever/screen_retriever.dart';

class OverlayPositioner {
  const OverlayPositioner();

  Future<Offset> computeTopCenterPosition({
    required Size windowSize,
    double topMargin = 96, // Raycast-like: un peu sous la barre
  }) async {
    try {
      final displays = await screenRetriever.getAllDisplays();
      final cursor = await screenRetriever.getCursorScreenPoint();

      // Trouver l’écran qui contient le curseur
      final active = displays.firstWhere(
        (d) => _contains(d.visiblePosition!, d.visibleSize!, cursor),
        orElse: () => displays.first,
      );

      final rectLeft = active.visiblePosition?.dx;
      final rectTop = active.visiblePosition?.dy;
      final rectW = active.visibleSize?.width;
      final rectH = active.visibleSize?.height;

      final x = rectLeft! + (rectW! - windowSize.width) / 2;
      final y = rectTop! + min(topMargin, max(24, rectH! * 0.12));

      return Offset(x.roundToDouble(), y.roundToDouble());
    } catch (e, stack) {
      developer.log(
        'Error computing overlay position: $e',
        name: 'OverlayPositioner',
        error: e,
        stackTrace: stack,
      );

      // Fallback to center of primary display
      final primary = await screenRetriever.getPrimaryDisplay();
      final rectLeft = primary.visiblePosition?.dx;
      final rectTop = primary.visiblePosition?.dy;
      final rectW = primary.visibleSize?.width;
      final rectH = primary.visibleSize?.height;
      final x = rectLeft! + (rectW! - windowSize.width) / 2;
      final y = rectTop! + min(topMargin, max(24, rectH! * 0.12));
      return Offset(x.roundToDouble(), y.roundToDouble());
    }
  }

  bool _contains(Offset pos, Size size, Offset p) {
    return p.dx >= pos.dx &&
        p.dy >= pos.dy &&
        p.dx <= pos.dx + size.width &&
        p.dy <= pos.dy + size.height;
  }
}
