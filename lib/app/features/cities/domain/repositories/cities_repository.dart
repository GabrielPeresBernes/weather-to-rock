import '../entities/city.dart';
import 'package:dartz/dartz.dart';

/// Retrieves stored cities.
abstract interface class CitiesRepository {
  /// Gets stored cities.
  ///
  /// A [query] can be passed to filter the results by city name.
  Future<Either<Exception, List<City>>> getCities(String? query);
}
