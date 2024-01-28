import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/local/weather_local_data_source.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/local/weather_local_data_source_impl.dart';
import 'package:weather_to_rock/app/shared/constants/app_constants.dart';
import 'package:weather_to_rock/core/infra/local_storage/local_storage.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../mocks/weather_mocks.dart';
import '../../../seeds/weather_seeds.dart';

main() {
  late CoreLocalStorage localStorage;
  late WeatherLocalDataSource dataSource;

  setUp(() {
    localStorage = MockLocalStorage();

    dataSource = WeatherLocalDataSourceImpl(
      localStorage: localStorage,
    );
  });

  group('weather_local_data_source', () {
    group('cache weather by city', () {
      test('should cache city weather', () async {
        // arrange
        when(() => localStorage.getValue<Map<String, dynamic>>(any(), any()))
            .thenReturn({});

        when(() => localStorage.setValue(any(), any()))
            .thenAnswer((_) async {});

        // act
        final result = await dataSource.cacheWeatherByCity(
          slug: WeatherSeeds.cityEntity.slug,
          forecast: WeatherSeeds.forecastLocalModel,
        );

        // assert
        expect(result.isRight(), true);

        verify(() => localStorage.getValue<Map<String, dynamic>>(
            AppConstants.localDataWeatherKey, {})).called(1);

        verify(() => localStorage.setValue(
              AppConstants.localDataWeatherKey,
              {
                WeatherSeeds.cityEntity.slug:
                    WeatherSeeds.forecastLocalModel.toJson(),
              },
            )).called(1);
      });

      test('should return exception when local storage fails', () async {
        // arrange
        when(() => localStorage.getValue<Map<String, dynamic>>(any(), any()))
            .thenReturn({});

        when(() => localStorage.setValue(any(), any())).thenThrow(Exception());

        // act
        final result = await dataSource.cacheWeatherByCity(
          slug: 'invalid',
          forecast: WeatherSeeds.forecastLocalModel,
        );

        // assert
        expect(result.isLeft(), true);
      });
    });

    group('get weather by city', () {
      test('should get city weather', () {
        // arrange
        final json =
            FixturesUtils.readFixtureAsMap('weather/weather_local.json');

        when(() => localStorage.getValue<Map<String, dynamic>>(any(), any()))
            .thenReturn(json);

        // act
        final result = dataSource.getWeatherByCity(
          WeatherSeeds.cityEntity.slug,
        );

        final forecast = result.getOrElse(() => throw Exception());

        // assert
        expect(result.isRight(), true);

        expect(forecast, WeatherSeeds.forecastLocalModel);

        verify(() => localStorage.getValue<Map<String, dynamic>>(
            AppConstants.localDataWeatherKey, {})).called(1);
      });

      test('should return exception when local storage fails', () async {
        // arrange
        when(() => localStorage.getValue(any(), any())).thenThrow(Exception());

        // act
        final result = dataSource.getWeatherByCity(
          'invalid',
        );

        // assert
        expect(result.isLeft(), true);
      });
    });

    group('get cached cities weather', () {
      test('should get all cached cities weather', () {
        // arrange
        final json =
            FixturesUtils.readFixtureAsMap('weather/weather_local.json');

        when(() => localStorage.getValue<Map<String, dynamic>>(any(), any()))
            .thenReturn(json);

        // act
        final result = dataSource.getCachedCitiesWeather();

        final forecast = result.getOrElse(() => throw Exception());

        // assert
        expect(result.isRight(), true);

        expect(forecast, json);

        verify(() => localStorage.getValue<Map<String, dynamic>>(
            AppConstants.localDataWeatherKey, {})).called(1);
      });

      test('should return exception when local storage fails', () async {
        // arrange
        when(() => localStorage.getValue(any(), any())).thenThrow(Exception());

        // act
        final result = dataSource.getCachedCitiesWeather();

        // assert
        expect(result.isLeft(), true);
      });
    });
  });
}
