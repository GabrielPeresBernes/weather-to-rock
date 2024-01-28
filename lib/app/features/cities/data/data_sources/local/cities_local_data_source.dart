import 'package:dartz/dartz.dart';

import '../../models/city_model.dart';

/// Retrieves cities from local storage.
abstract interface class CitiesLocalDataSource {
  /// Gets cities from local storage.
  ///
  /// A [query] can be passed to filter the results by city name.
  Future<Either<Exception, List<CityModel>>> getCities(String? query);
}
