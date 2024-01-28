import 'package:flutter_test/flutter_test.dart';
import 'package:weather_to_rock/app/features/weather/data/models/local/forecast_local_model.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../seeds/weather_seeds.dart';

void main() {
  group('forecast_local_model', () {
    test('should return a valid model from JSON', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_local.json')['sp'];

      // act
      final result = ForecastLocalModel.fromJson(json);

      // assert
      expect(result, WeatherSeeds.forecastLocalModel);
    });

    test('should return a valid model from Entity', () {
      // arrange
      final entity = WeatherSeeds.forecastEntity;

      // act
      final result = ForecastLocalModel.fromEntity(entity);

      // assert
      expect(result, WeatherSeeds.forecastLocalModel);
    });

    test('should map to a valid JSON', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_local.json')['sp'];

      // act
      final model = ForecastLocalModel.fromJson(json);

      final result = model.toJson();

      // assert
      expect(result, json);
    });

    test('should map to a valid Entity', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_local.json')['sp'];

      // act
      final model = ForecastLocalModel.fromJson(json);

      final result = model.toEntity();

      // assert
      expect(result, WeatherSeeds.forecastEntity);
    });
  });
}
