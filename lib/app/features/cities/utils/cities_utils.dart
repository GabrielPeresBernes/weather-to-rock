import '../domain/entities/city.dart';

abstract final class CitiesUtils {
  static bool isCityWeatherCached({
    required City city,
    required Map<String, dynamic> data,
  }) {
    return city.isCached || data[city.slug] != null;
  }
}
