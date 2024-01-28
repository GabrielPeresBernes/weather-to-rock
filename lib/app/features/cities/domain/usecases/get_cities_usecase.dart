import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_to_rock/app/features/cities/domain/repositories/cities_repository.dart';

import '../../../../../core/interfaces/use_case.dart';
import '../../../weather/domain/repositories/weather_repository.dart';
import '../entities/city.dart';

/// Gets stored cities.
class GetCitiesUseCase implements UseCase<List<City>, GetCitiesParams> {
  const GetCitiesUseCase({
    required this.citiesRepository,
    required this.weatherRepository,
  });

  final CitiesRepository citiesRepository;
  final WeatherRepository weatherRepository;

  @override
  Future<Either<Exception, List<City>>> call(GetCitiesParams params) async {
    final citiesResponse = await citiesRepository.getCities(params.query);

    return citiesResponse.fold(
      (exception) => Left(exception),
      (cities) {
        final weatherResponse = weatherRepository.getCachedCitiesWeather();

        final citiesWeather = weatherResponse.fold(
          (exception) => {},
          (data) => data,
        );

        return Right(
          cities
              .map(
                (city) => City(
                  flag: city.flag,
                  name: city.name,
                  slug: city.slug,
                  lat: city.lat,
                  lng: city.lng,
                  country: city.country,
                  isCached: citiesWeather[city.slug] != null ? true : false,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class GetCitiesParams extends Equatable {
  const GetCitiesParams({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}
