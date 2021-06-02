import 'package:get_it/get_it.dart';
import 'package:recipiebook/services/app_services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppServices());
}
