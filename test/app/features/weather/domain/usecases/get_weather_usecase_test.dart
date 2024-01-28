
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_to_rock/app/features/weather/domain/usecases/get_weather_usecase.dart';

import '../../mocks/weather_mocks.dart';
import '../../seeds/weather_seeds.dart';

main() {
  late WeatherRepository repository;
  late GetWeatherUseCase usecase;

  setUp(() {
    repository = MockWeatherRepository();

    usecase = GetWeatherUseCase(weatherRepository: repository);
  });

  group('get_weather_usecase', () {
    test('should return a valid forecast', () async {
      // arrange
      when(() => repository.getWetherForecastByCity(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
            slug: any(named: 'slug'),
          )).thenAnswer(
        (_) async => Right(WeatherSeeds.forecastEntity),
      );

      // act
      final result = await usecase(
        const GetWeatherParams(lat: 'lat', lng: 'lng', slug: 'slug'),
      );

      final forecast = result.getOrElse(() => throw (Exception()));

      // assert
      expect(result.isRight(), true);

      expect(forecast, WeatherSeeds.forecastEntity);

      verify(() => repository.getWetherForecastByCity(
            lat: 'lat',
            lng: 'lng',
            slug: 'slug',
          )).called(1);
    });

    test('should return exception when repository fails', () async {
      // arrange
      when(() => repository.getWetherForecastByCity(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
            slug: any(named: 'slug'),
          )).thenAnswer(
        (_) async => Left(Exception()),
      );

      // act
      final result = await usecase(
        const GetWeatherParams(lat: 'lat', lng: 'lng', slug: 'slug'),
      );

      // assert
      expect(result.isLeft(), true);
    });
  });
}
