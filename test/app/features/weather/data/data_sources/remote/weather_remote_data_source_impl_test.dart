import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/remote/weather_remote_data_source.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/remote/weather_remote_data_source_impl.dart';
import 'package:weather_to_rock/core/infra/network/network.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../mocks/weather_mocks.dart';
import '../../../seeds/weather_seeds.dart';

main() async {
  late CoreNetwork client;
  late WeatherRemoteDataSource dataSource;

  setUpAll(() async {
    // TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
  });

  setUp(() {
    client = MockNetwork();

    dataSource = WeatherRemoteDataSourceImpl(
      client: client,
    );
  });

  group('weather_remote_data_source', () {
    group('get current weather by coordinates', () {
      test('should get current weather by coordinates', () async {
        // arrange
        final json =
            FixturesUtils.readFixtureAsMap('weather/weather_remote.json');

        when(() => client.get(any(), queryParams: any(named: 'queryParams')))
            .thenAnswer((_) async => json);

        // act
        final result = await dataSource.getCurrentWeatherByCoordinates(
          lat: WeatherSeeds.cityEntity.lat,
          lng: WeatherSeeds.cityEntity.lng,
        );

        final forecast = result.getOrElse(() => throw Exception());

        // assert
        expect(result.isRight(), true);

        expect(forecast, WeatherSeeds.forecastRemoteModelCurrent);

        verify(() => client.get(
              '/weather',
              queryParams: {
                "lat": WeatherSeeds.cityEntity.lat,
                "lon": WeatherSeeds.cityEntity.lng,
                "appid": dotenv.env['API_KEY']!,
              },
            )).called(1);
      });

      test('should return exception when client fails', () async {
        // arrange
        when(() => client.get(any(), queryParams: any(named: 'queryParams')))
            .thenThrow(Exception());

        // act
        final result = await dataSource.getCurrentWeatherByCoordinates(
          lat: 'invalid',
          lng: 'invalid',
        );

        // assert
        expect(result.isLeft(), true);
      });
    });
  });

  group('get future weather by coordinates', () {
    test('should get future weather by coordinates', () async {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/forecast_remote.json');

      when(() => client.get(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => json);

      // act
      final result = await dataSource.getFutureWeatherByCoordinates(
        lat: WeatherSeeds.cityEntity.lat,
        lng: WeatherSeeds.cityEntity.lng,
      );

      final forecasts = result.getOrElse(() => throw Exception());

      // assert
      expect(result.isRight(), true);

      expect(forecasts, WeatherSeeds.forecastRemoteModelFutures);

      verify(() => client.get(
            '/forecast',
            queryParams: {
              "lat": WeatherSeeds.cityEntity.lat,
              "lon": WeatherSeeds.cityEntity.lng,
              "appid": dotenv.env['API_KEY']!,
            },
          )).called(1);
    });

    test('should return exception when client fails', () async {
      // arrange
      when(() => client.get(any(), queryParams: any(named: 'queryParams')))
          .thenThrow(Exception());

      // act
      final result = await dataSource.getFutureWeatherByCoordinates(
        lat: 'invalid',
        lng: 'invalid',
      );

      // assert
      expect(result.isLeft(), true);
    });
  });
}
