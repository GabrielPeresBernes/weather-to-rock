import 'package:dartz/dartz.dart';

import '../entities/forecast.dart';

/// Retrieves weather forecast.
abstract interface class WeatherRepository {
  /// Gets current weather and 5 days forecast by city.
  ///
  /// Requires a city identifier [slug].
  Future<Either<Exception, Forecast>> getWetherForecastByCity({
    required String lat,
    required String lng,
    required String slug,
  });

  /// Gets a list of cities with cached weather forecast.
  Either<Exception, Map<String, dynamic>> getCachedCitiesWeather();
}
