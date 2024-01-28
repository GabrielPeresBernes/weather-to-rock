import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/cities/domain/repositories/cities_repository.dart';
import 'package:weather_to_rock/app/features/cities/domain/usecases/get_cities_usecase.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';

import '../../../../../utils/fixtures_utils.dart';
import '../../mocks/cities_mocks.dart';
import '../../seeds/cities_seeds.dart';

main() {
  late WeatherRepository weatherRepository;
  late CitiesRepository citiesRepository;
  late GetCitiesUseCase getCities;

  setUp(() {
    citiesRepository = MockCitiesRepository();

    weatherRepository = MockWeatherRepository();

    getCities = GetCitiesUseCase(
      citiesRepository: citiesRepository,
      weatherRepository: weatherRepository,
    );
  });

  group('get_cities_usecase', () {
    test('should return cities when no one is cached', () async {
      // arrange
      when(() => citiesRepository.getCities(any()))
          .thenAnswer((_) async => const Right(CitiesSeeds.citiesEntities));

      when(() => weatherRepository.getCachedCitiesWeather())
          .thenAnswer((_) => const Right({}));

      // act
      final result = await getCities(const GetCitiesParams());

      final cities = result.getOrElse(() => throw Exception());

      // assert
      verify(() => citiesRepository.getCities(null)).called(1);

      verify(() => weatherRepository.getCachedCitiesWeather()).called(1);

      expect(result.isRight(), true);

      expect(cities, CitiesSeeds.citiesEntities);
    });

    test('should return cities when some is cached', () async {
      // arrange
      when(() => citiesRepository.getCities(any()))
          .thenAnswer((_) async => const Right(CitiesSeeds.citiesEntities));

      when(() => weatherRepository.getCachedCitiesWeather()).thenAnswer(
        (_) =>
            Right(FixturesUtils.readFixtureAsMap('cities/cities_cached.json')),
      );

      // act
      final result = await getCities(const GetCitiesParams());

      final cities = result.getOrElse(() => throw Exception());

      // assert
      verify(() => citiesRepository.getCities(null)).called(1);

      verify(() => weatherRepository.getCachedCitiesWeather()).called(1);

      expect(result.isRight(), true);

      expect(cities, CitiesSeeds.citiesEntitiesCached);
    });

    test('should return filtered cities when query is provided', () async {
      // arrange
      when(() => citiesRepository.getCities(any()))
          .thenAnswer((_) async => Right([CitiesSeeds.citiesEntities[0]]));

      when(() => weatherRepository.getCachedCitiesWeather())
          .thenAnswer((_) => const Right({}));

      // act
      final result = await getCities(const GetCitiesParams(
        query: CitiesSeeds.citySearch,
      ));

      final cities = result.getOrElse(() => throw Exception());

      // assert
      verify(() => citiesRepository.getCities(CitiesSeeds.citySearch))
          .called(1);

      verify(() => weatherRepository.getCachedCitiesWeather()).called(1);

      expect(result.isRight(), true);

      expect(cities, [CitiesSeeds.citiesEntities[0]]);
    });

    test('should return exception when cities repository result in error',
        () async {
      // arrange
      when(() => citiesRepository.getCities(any()))
          .thenAnswer((_) async => Left(Exception()));

      // act
      final result = await getCities(const GetCitiesParams());

      // assert
      expect(result.isLeft(), true);
    });

    test('should not return exception when weather repository result in error',
        () async {
      // arrange
      when(() => citiesRepository.getCities(any()))
          .thenAnswer((_) async => const Right(CitiesSeeds.citiesEntities));

      when(() => weatherRepository.getCachedCitiesWeather())
          .thenAnswer((_) => Left(Exception()));

      // act
      final result = await getCities(const GetCitiesParams());

      final cities = result.getOrElse(() => throw Exception());

      // assert
      expect(result.isRight(), true);

      expect(cities, CitiesSeeds.citiesEntities);
    });
  });
}
