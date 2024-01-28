import 'package:dartz/dartz.dart';
import 'package:weather_to_rock/core/infra/local_storage/core_local_storage.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../models/local/forecast_local_model.dart';
import 'weather_local_data_source.dart';

final class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  const WeatherLocalDataSourceImpl({
    required this.localStorage,
  });

  final CoreLocalStorage localStorage;

  @override
  Future<Either<Exception, void>> cacheWeatherByCity({
    required String slug,
    required ForecastLocalModel forecast,
  }) async {
    try {
      final data = localStorage.getValue<Map<String, dynamic>>(
        AppConstants.localDataWeatherKey,
        {},
      );

      data[slug] = forecast.toJson();

      await localStorage.setValue(
        AppConstants.localDataWeatherKey,
        data,
      );

      return const Right(null);
    } catch (exception) {
      return Left(Exception(exception));
    }
  }

  @override
  Either<Exception, ForecastLocalModel?> getWeatherByCity(String slug) {
    try {
      final data = localStorage.getValue<Map<String, dynamic>>(
        AppConstants.localDataWeatherKey,
        {},
      );

      return Right(
        data[slug] == null ? null : ForecastLocalModel.fromJson(data[slug]),
      );
    } catch (exception) {
      return Left(Exception(exception));
    }
  }

  @override
  Either<Exception, Map<String, dynamic>> getCachedCitiesWeather() {
    try {
      final data = localStorage.getValue<Map<String, dynamic>>(
        AppConstants.localDataWeatherKey,
        {},
      );

      return Right(data);
    } catch (exception) {
      return Left(Exception(exception));
    }
  }
}
