import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/local/weather_local_data_source.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/remote/weather_remote_data_source.dart';
import 'package:weather_to_rock/app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_to_rock/core/exceptions/connection_exception.dart';

import '../../mocks/weather_mocks.dart';
import '../../seeds/weather_seeds.dart';

main() {
  late WeatherRemoteDataSource remoteDataSource;
  late WeatherLocalDataSource localDataSource;
  late Connectivity connectivity;
  late WeatherRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeForecastLocalModel());
  });

  setUp(() {
    remoteDataSource = MockWeatherRemoteDataSource();

    localDataSource = MockWeatherLocalDataSource();

    connectivity = MockConnectivity();

    repository = WeatherRepositoryImpl(
      weatherRemoteDataSource: remoteDataSource,
      weatherLocalDataSource: localDataSource,
      connectivity: connectivity,
    );
  });

  group('weather_repository', () {
    test('should return a valid forecast when connected', () async {
      // arrange
      when(() => connectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );

      when(
        () => remoteDataSource.getCurrentWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Right(WeatherSeeds.forecastRemoteModelCurrent),
      );

      when(
        () => remoteDataSource.getFutureWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Right(WeatherSeeds.forecastRemoteModelFutures),
      );

      when(
        () => localDataSource.cacheWeatherByCity(
          slug: any(named: 'slug'),
          forecast: any(named: 'forecast'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final result = await repository.getWetherForecastByCity(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      );

      final forecast = result.getOrElse(() => throw (Exception()));

      // assert
      expect(result.isRight(), true);

      expect(forecast, WeatherSeeds.forecastEntity);

      verify(
        () => remoteDataSource.getCurrentWeatherByCoordinates(
          lat: 'lat',
          lng: 'lng',
        ),
      ).called(1);

      verify(
        () => remoteDataSource.getFutureWeatherByCoordinates(
          lat: 'lat',
          lng: 'lng',
        ),
      ).called(1);

      verify(
        () => localDataSource.cacheWeatherByCity(
          slug: 'slug',
          forecast: WeatherSeeds.forecastLocalModel,
        ),
      ).called(1);

      verifyNever(
        () => localDataSource.getWeatherByCity(any()),
      );
    });

    test(
        'should return a valid forecast when not connected and data is available',
        () async {
      // arrange
      when(() => connectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.none,
      );

      when(
        () => localDataSource.getWeatherByCity(any()),
      ).thenAnswer(
        (_) => Right(WeatherSeeds.forecastLocalModel),
      );

      // act
      final result = await repository.getWetherForecastByCity(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      );

      final forecast = result.getOrElse(() => throw (Exception()));

      // assert
      expect(result.isRight(), true);

      expect(forecast, WeatherSeeds.forecastEntity);

      verify(
        () => localDataSource.getWeatherByCity('slug'),
      ).called(1);

      verifyNever(
        () => remoteDataSource.getCurrentWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      );

      verifyNever(
        () => remoteDataSource.getFutureWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      );

      verifyNever(
        () => localDataSource.cacheWeatherByCity(
          slug: any(named: 'slug'),
          forecast: any(named: 'forecast'),
        ),
      );
    });

    test(
        'should throw a ConnectionException when not connected and data is not available',
        () async {
      // arrange
      when(() => connectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.none,
      );

      when(
        () => localDataSource.getWeatherByCity(any()),
      ).thenAnswer(
        (_) => const Right(null),
      );

      // act
      final result = await repository.getWetherForecastByCity(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      );

      // assert
      expect(result.isLeft(), true);

      expect(result.fold((l) => l, (r) => r), isA<ConnectionException>());
    });

    test('should throw a Exception when get current wether method fails',
        () async {
      // arrange
      when(() => connectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );

      when(
        () => remoteDataSource.getCurrentWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Left(Exception()),
      );

      // act
      final result = await repository.getWetherForecastByCity(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      );

      // assert
      expect(result.isLeft(), true);
    });

    test('should throw a Exception when get future wether method fails',
        () async {
      // arrange
      when(() => connectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );

      when(
        () => remoteDataSource.getCurrentWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Right(WeatherSeeds.forecastRemoteModelCurrent),
      );

      when(
        () => remoteDataSource.getFutureWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Left(Exception()),
      );

      // act
      final result = await repository.getWetherForecastByCity(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      );

      // assert
      expect(result.isLeft(), true);
    });

    test('should not throw a Exception when cache wether method fails',
        () async {
      // arrange
      when(() => connectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );

      when(
        () => remoteDataSource.getCurrentWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Right(WeatherSeeds.forecastRemoteModelCurrent),
      );

      when(
        () => remoteDataSource.getFutureWeatherByCoordinates(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        ),
      ).thenAnswer(
        (_) async => Right(WeatherSeeds.forecastRemoteModelFutures),
      );

      when(
        () => localDataSource.cacheWeatherByCity(
          slug: any(named: 'slug'),
          forecast: any(named: 'forecast'),
        ),
      ).thenAnswer(
        (_) async => Left(Exception()),
      );

      // act
      final result = await repository.getWetherForecastByCity(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      );

      final forecast = result.getOrElse(() => throw (Exception()));

      // assert
      expect(result.isRight(), true);

      expect(forecast, WeatherSeeds.forecastEntity);
    });

    test('should return cached cities weather', () async {
      // arrange
      when(
        () => localDataSource.getCachedCitiesWeather(),
      ).thenAnswer(
        (_) => const Right({}),
      );

      // act
      final result = repository.getCachedCitiesWeather();

      final forecast = result.getOrElse(() => throw (Exception()));

      // assert
      expect(result.isRight(), true);

      expect(forecast, {});
    });
  });
}
