import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/di/di.dart';

final getIt = GetIt.instance;

@InjectableInit(
  
)
Future<void> configureDependencies() => getIt.init();
