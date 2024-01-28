import 'package:dartz/dartz.dart';
import 'package:weather_to_rock/app/features/cities/data/data_sources/local/cities_local_data_source.dart';

import '../../domain/entities/city.dart';
import '../../domain/repositories/cities_repository.dart';

final class CitiesRepositoryImpl implements CitiesRepository {
  const CitiesRepositoryImpl({
    required this.citiesLocalDataSource,
  });

  final CitiesLocalDataSource citiesLocalDataSource;

  @override
  Future<Either<Exception, List<City>>> getCities(String? query) async {
    final result = await citiesLocalDataSource.getCities(query);

    return result.map(
      (cities) => cities.map((city) => city.toEntity()).toList(),
    );
  }
}
