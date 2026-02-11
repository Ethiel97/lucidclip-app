import 'dart:async' as async;

extension FutureExtension<T> on Future<T> {
  void unawaited() => async.unawaited(this);
}
