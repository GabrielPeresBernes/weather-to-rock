import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:weather_to_rock/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_to_rock/core/exceptions/connection_exception.dart';

import '../../mocks/weather_mocks.dart';
import '../../seeds/weather_seeds.dart';

main() {
  late GetWeatherUseCase getWeather;

  setUpAll(() {
    registerFallbackValue(FakeGetWeatherParams());
  });

  setUp(() {
    getWeather = MockGetWeatherUseCase();
  });

  WeatherBloc buildBloc() => WeatherBloc(getWeather: getWeather);

  group('weather_bloc', () {
    blocTest<WeatherBloc, WeatherState>(
      'emits success state when usecase returns list with wether',
      setUp: () {
        when(
          () => getWeather(any()),
        ).thenAnswer((_) async => Right(WeatherSeeds.forecastEntity));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const WeatherGetForecast(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      )),
      expect: () => [
        const WeatherState(status: WeatherStatus.loading),
        WeatherState(
          forecast: WeatherSeeds.forecastEntity,
          status: WeatherStatus.success,
        ),
      ],
      verify: (bloc) {
        verify(
          () => getWeather(const GetWeatherParams(
            lat: 'lat',
            lng: 'lng',
            slug: 'slug',
          )),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits error state when usecase returns error',
      setUp: () {
        when(
          () => getWeather(any()),
        ).thenAnswer((_) async => Left(Exception()));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const WeatherGetForecast(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      )),
      expect: () => const [
        WeatherState(status: WeatherStatus.loading),
        WeatherState(status: WeatherStatus.failure),
      ],
      verify: (bloc) {
        verify(
          () => getWeather(const GetWeatherParams(
            lat: 'lat',
            lng: 'lng',
            slug: 'slug',
          )),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits not connected error when usecase returns connection exception',
      setUp: () {
        when(
          () => getWeather(any()),
        ).thenAnswer((_) async => const Left(ConnectionException()));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const WeatherGetForecast(
        lat: 'lat',
        lng: 'lng',
        slug: 'slug',
      )),
      expect: () => const [
        WeatherState(status: WeatherStatus.loading),
        WeatherState(status: WeatherStatus.notConnected),
      ],
      verify: (bloc) {
        verify(
          () => getWeather(const GetWeatherParams(
            lat: 'lat',
            lng: 'lng',
            slug: 'slug',
          )),
        ).called(1);
      },
    );
  });
}
