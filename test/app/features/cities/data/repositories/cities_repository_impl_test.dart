import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/cities/data/data_sources/local/cities_local_data_source.dart';
import 'package:weather_to_rock/app/features/cities/data/repositories/cities_repository_impl.dart';
import 'package:weather_to_rock/app/features/cities/domain/repositories/cities_repository.dart';

import '../../mocks/cities_mocks.dart';
import '../../seeds/cities_seeds.dart';

void main() {
  late CitiesLocalDataSource citiesLocalDataSource;
  late CitiesRepository citiesRepository;

  setUp(() {
    citiesLocalDataSource = MockCitiesLocalDataSource();

    citiesRepository = CitiesRepositoryImpl(
      citiesLocalDataSource: citiesLocalDataSource,
    );
  });

  group('cities_repository_impl', () {
    test('should get cities from local data source when query input is empty',
        () async {
      // arrange
      when(() => citiesLocalDataSource.getCities(any()))
          .thenAnswer((_) async => const Right(CitiesSeeds.citiesModels));

      // act
      final result = await citiesRepository.getCities(null);

      final cities = result.getOrElse(() => throw Exception());

      // assert
      verify(() => citiesLocalDataSource.getCities(null)).called(1);

      expect(result.isRight(), true);

      expect(cities, CitiesSeeds.citiesEntities);
    });

    test('should return cities when query input is provided', () async {
      // arrange
      when(() => citiesLocalDataSource.getCities(any()))
          .thenAnswer((_) async => Right([CitiesSeeds.citiesModels[0]]));

      // act
      final result = await citiesRepository.getCities(CitiesSeeds.citySearch);

      final cities = result.getOrElse(() => throw Exception());

      // assert
      verify(() => citiesLocalDataSource.getCities(CitiesSeeds.citySearch))
          .called(1);

      expect(result.isRight(), true);

      expect(cities, [CitiesSeeds.citiesEntities[0]]);
    });

    test('should return exception when data source result in error', () async {
      // arrange
      when(() => citiesLocalDataSource.getCities(any()))
          .thenAnswer((_) async => Left(Exception()));

      // act
      final result = await citiesRepository.getCities(null);

      // assert
      verify(() => citiesLocalDataSource.getCities(null)).called(1);

      expect(result.isLeft(), true);
    });
  });
}
