import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/constants/constants.dart';
import 'package:lucid_clip/core/storage/storage.dart';

@LazySingleton(as: StorageService)
class HiveStorageService implements StorageService {
  HiveStorageService(@Named('hiveAdapters') List<TypeAdapter> adapters)
      : _adapters = adapters;

  final List<TypeAdapter> _adapters;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  @PostConstruct()
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter(AppConstants.storageDirectory);

    for (final adapter in _adapters) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    _isInitialized = true;
  }

  @override
  Future<void> put<T>(String collection, String key, T value) async {
    final box = await _openBox<T>(collection);
    await box.put(key, value);
  }

  @override
  Future<List<T>> getAll<T>(String collection) async {
    final box = await _openBox<T>(collection);
    return box.values.whereType<T>().toList();
  }

  @override
  Stream<List<T>> watch<T>(String collection) async* {
    final box = await _openBox<T>(collection);

    yield box.values.whereType<T>().toList();

    yield* box.watch().asyncMap((_) => box.values.whereType<T>().toList());
  }

  Future<Box<T>> _openBox<T>(String name) async {
    if (!_isInitialized) {
      throw StateError('Storage not initialized');
    }

    return Hive.isBoxOpen(name)
        ? Hive.box<T>(name)
        : await Hive.openBox<T>(name);
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await Hive.close();
    _isInitialized = false;
  }

  @override
  Future<void> clear(String collection) async {
    final box = await _openBox<dynamic>(collection);
    await box.clear();
  }

  @override
  Future<void> clearAllData() async {
    return Hive.deleteFromDisk();
  }

  @override
  Future<bool> containsKey(String collection, String key) {
    final boxFuture = _openBox<dynamic>(collection);
    return boxFuture.then((box) => box.containsKey(key));
  }

  @override
  Future<int> count(String collection) async {
    final boxFuture = _openBox<dynamic>(collection);
    return boxFuture.then((box) => box.length);
  }

  @override
  Future<void> delete(String collection, String key) async {
    final boxFuture = _openBox<dynamic>(collection);
    return boxFuture.then((box) => box.delete(key));
  }

  @override
  Future<T?> get<T>(String collection, String key) {
    final boxFuture = _openBox<T>(collection);
    return boxFuture.then((box) => box.get(key));
  }
}
