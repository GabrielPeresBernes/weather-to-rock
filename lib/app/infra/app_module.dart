import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/infra/local_storage/local_storage.dart';
import '../../core/infra/network/network.dart';
import '../../core/interfaces/core_module.dart';
import '../features/cities/infra/cities_module.dart';
import '../features/weather/infra/weather_module.dart';
import 'router/app_router.dart';

final class AppModule implements CoreModule {
  const AppModule();

  @override
  Future<void> init() async {
    // Third-party
    final coreLocalStorage = await SharedPreferencesImpl.init();

    GetIt.I.registerLazySingleton<CoreLocalStorage>(() => coreLocalStorage);

    GetIt.I.registerLazySingleton<Connectivity>(() => Connectivity());

    // Core
    GetIt.I.registerLazySingleton<AppRouter>(() => const AppRouter());

    GetIt.I.registerLazySingleton<CoreNetwork>(
      () => HttpNetworkImpl(baseUrl: dotenv.env['API_URL']!),
    );

    // Modules
    const CitiesModule().init();

    const WeatherModule().init();
  }
}
