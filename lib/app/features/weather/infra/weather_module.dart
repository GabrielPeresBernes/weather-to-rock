import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_to_rock/core/infra/local_storage/local_storage.dart';
import 'package:weather_to_rock/core/infra/network/network.dart';
import 'package:weather_to_rock/core/interfaces/core_module.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_to_rock/app/features/weather/presentation/bloc/weather_bloc.dart';

import '../data/data_sources/local/weather_local_data_source.dart';
import '../data/data_sources/local/weather_local_data_source_impl.dart';
import '../data/data_sources/remote/weather_remote_data_source.dart';
import '../data/data_sources/remote/weather_remote_data_source_impl.dart';
import '../data/repositories/weather_repository_impl.dart';
import '../domain/usecases/get_weather_usecase.dart';

final class WeatherModule implements CoreModule {
  const WeatherModule();

  @override
  Future<void> init() async {
    GetIt.I.registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(
        client: GetIt.I.get<CoreNetwork>(),
      ),
    );

    GetIt.I.registerLazySingleton<WeatherLocalDataSource>(
      () => WeatherLocalDataSourceImpl(
        localStorage: GetIt.I.get<CoreLocalStorage>(),
      ),
    );

    GetIt.I.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
        weatherRemoteDataSource: GetIt.I.get<WeatherRemoteDataSource>(),
        weatherLocalDataSource: GetIt.I.get<WeatherLocalDataSource>(),
        connectivity: GetIt.I.get<Connectivity>(),
      ),
    );

    GetIt.I.registerLazySingleton<GetWeatherUseCase>(
      () => GetWeatherUseCase(
        weatherRepository: GetIt.I.get<WeatherRepository>(),
      ),
    );

    GetIt.I.registerFactory<WeatherBloc>(
      () => WeatherBloc(
        getWeather: GetIt.I.get<GetWeatherUseCase>(),
      ),
    );
  }
}
