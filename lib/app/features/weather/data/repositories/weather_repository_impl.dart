import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_to_rock/app/features/weather/data/models/local/forecast_local_model.dart';

import '../../../../../core/exceptions/connection_exception.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../data_sources/local/weather_local_data_source.dart';
import '../data_sources/remote/weather_remote_data_source.dart';

final class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl({
    required this.weatherRemoteDataSource,
    required this.weatherLocalDataSource,
    required this.connectivity,
  });

  final WeatherRemoteDataSource weatherRemoteDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;
  final Connectivity connectivity;

  @override
  Future<Either<Exception, Forecast>> getWetherForecastByCity({
    required String lat,
    required String lng,
    required String slug,
  }) async {
    final connection = await connectivity.checkConnectivity();

    if (connection == ConnectivityResult.none) {
      final result = weatherLocalDataSource.getWeatherByCity(slug);

      return result.flatMap(
        (forecast) {
          if (forecast == null) {
            return const Left(ConnectionException('No internet connection'));
          }

          return Right(forecast.toEntity());
        },
      );
    }

    final currentWeatherResult =
        await weatherRemoteDataSource.getCurrentWeatherByCoordinates(
      lat: lat,
      lng: lng,
    );

    return currentWeatherResult.fold(
      (exception) => Left(exception),
      (currentWeather) async {
        final futureWeatherResult =
            await weatherRemoteDataSource.getFutureWeatherByCoordinates(
          lat: lat,
          lng: lng,
        );

        return futureWeatherResult.fold(
          (exception) => Left(exception),
          (futureWeather) async {
            final forecast = Forecast(
              current: currentWeather.toEntity(),
              futures: futureWeather.map((item) => item.toEntity()).toList(),
            );

            await weatherLocalDataSource.cacheWeatherByCity(
              slug: slug,
              forecast: ForecastLocalModel.fromEntity(forecast),
            );

            return Right(forecast);
          },
        );
      },
    );
  }

  @override
  Either<Exception, Map<String, dynamic>> getCachedCitiesWeather() {
    return weatherLocalDataSource.getCachedCitiesWeather();
  }
}
