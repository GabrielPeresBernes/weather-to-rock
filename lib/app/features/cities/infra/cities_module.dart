import 'package:get_it/get_it.dart';
import 'package:weather_to_rock/core/interfaces/core_module.dart';
import 'package:weather_to_rock/app/features/cities/data/data_sources/local/cities_local_data_source.dart';
import 'package:weather_to_rock/app/features/cities/data/data_sources/local/cities_local_data_source_impl.dart';
import 'package:weather_to_rock/app/features/cities/data/repositories/cities_repository_impl.dart';
import 'package:weather_to_rock/app/features/cities/presentation/bloc/cities_bloc.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';

import '../../../../core/infra/local_storage/local_storage.dart';
import '../domain/repositories/cities_repository.dart';
import '../domain/usecases/get_cities_usecase.dart';

final class CitiesModule implements CoreModule {
  const CitiesModule();

  @override
  Future<void> init() async {
    GetIt.I.registerLazySingleton<CitiesLocalDataSource>(
      () => const CitiesLocalDataSourceImpl(),
    );

    GetIt.I.registerLazySingleton<CitiesRepository>(
      () => CitiesRepositoryImpl(
        citiesLocalDataSource: GetIt.I.get<CitiesLocalDataSource>(),
      ),
    );

    GetIt.I.registerLazySingleton<GetCitiesUseCase>(
      () => GetCitiesUseCase(
        citiesRepository: GetIt.I.get<CitiesRepository>(),
        weatherRepository: GetIt.I.get<WeatherRepository>(),
      ),
    );

    GetIt.I.registerFactory<CitiesBloc>(
      () => CitiesBloc(
        getCities: GetIt.I.get<GetCitiesUseCase>(),
        localStorage: GetIt.I.get<CoreLocalStorage>(),
      ),
    );
  }
}
