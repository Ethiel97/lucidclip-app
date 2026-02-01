import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/storage/secure_storage_service.dart';
import 'package:uuid/uuid.dart';

//ignore: one_member_abstracts
abstract class DeviceIdProvider {
  Future<String> getInstallationId();
}

@LazySingleton(as: DeviceIdProvider)
class SecureInstallationIdProvider implements DeviceIdProvider {
  SecureInstallationIdProvider(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  static const _key = 'lucidclip.installation_id';
  final _uuid = const Uuid();

  @override
  Future<String> getInstallationId() async {
    var installationId = await _secureStorageService.read(key: _key);

    if (installationId == null || installationId.isEmpty) {
      installationId = _uuid.v4();
      await _secureStorageService.write(key: _key, value: installationId);
    }

    return installationId;
  }
}
