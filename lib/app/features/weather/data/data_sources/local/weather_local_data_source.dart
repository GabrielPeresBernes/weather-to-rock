import 'package:dartz/dartz.dart';

import '../../models/local/forecast_local_model.dart';

/// Retrieves weather from local storage.
abstract interface class WeatherLocalDataSource {
  /// Gets weather by city from local storage.
  ///
  /// Requires a city identifier [slug].
  Either<Exception, ForecastLocalModel?> getWeatherByCity(String slug);

  /// Caches weather by city.
  ///
  /// Requires a city identifier [slug].
  Future<Either<Exception, void>> cacheWeatherByCity({
    required String slug,
    required ForecastLocalModel forecast,
  });

  /// Gets all cached cities weather.
  Either<Exception, Map<String, dynamic>> getCachedCitiesWeather();
}
