import 'package:dartz/dartz.dart';

import '../../models/remote/forecast_remote_model.dart';

/// Retrieves weather from remote API.
abstract interface class WeatherRemoteDataSource {
  /// Gets current weather by city
  Future<Either<Exception, ForecastRemoteModel>>
      getCurrentWeatherByCoordinates({
    required String lat,
    required String lng,
  });

  /// Gets 5 days weather forecast by city
  Future<Either<Exception, List<ForecastRemoteModel>>>
      getFutureWeatherByCoordinates({
    required String lat,
    required String lng,
  });
}
