import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';

@LazySingleton(as: AccessibilityRepository)
class AccessibilityRepositoryImpl implements AccessibilityRepository {
  AccessibilityRepositoryImpl({required this.dataSource});

  final StreamController<bool> _permissionStatusController =
      StreamController<bool>.broadcast();

  final AccessibilityDataSource dataSource;

  @override
  Future<bool> checkPermission() async {
    final result = await dataSource.checkPermission();
    _permissionStatusController.add(result);
    return result;
  }

  @override
  Future<bool> requestPermission() => dataSource.requestPermission();

  @override
  Stream<bool> get permissionStatusStream {
    return _permissionStatusController.stream.distinct();
  }
}
