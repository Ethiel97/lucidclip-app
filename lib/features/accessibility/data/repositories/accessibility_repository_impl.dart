import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';

@LazySingleton(as: AccessibilityRepository)
class AccessibilityRepositoryImpl implements AccessibilityRepository {
  const AccessibilityRepositoryImpl({required this.dataSource});

  final AccessibilityDataSource dataSource;

  @override
  Future<bool> checkPermission() => dataSource.checkPermission();

  @override
  Future<bool> requestPermission() => dataSource.requestPermission();
}
