import 'package:flutter_test/flutter_test.dart';
import 'package:weather_to_rock/app/features/weather/data/models/local/weather_local_model.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../seeds/weather_seeds.dart';

void main() {
  group('weather_local_model', () {
    test('should return a valid model from JSON', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_local.json')['sp']
              ['current'];

      // act
      final result = WeatherLocalModel.fromJson(json);

      // assert
      expect(result, WeatherSeeds.weatherLocalModels[0]);
    });

    test('should return a valid model from Entity', () {
      // arrange
      final entity = WeatherSeeds.weatherEntities[0];

      // act
      final result = WeatherLocalModel.fromEntity(entity);

      // assert
      expect(result, WeatherSeeds.weatherLocalModels[0]);
    });

    test('should map to a valid JSON', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_local.json')['sp']
              ['current'];

      // act
      final model = WeatherLocalModel.fromJson(json);

      final result = model.toJson();

      // assert
      expect(result, json);
    });

    test('should map to a valid Entity', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_local.json')['sp']
              ['current'];

      // act
      final model = WeatherLocalModel.fromJson(json);

      final result = model.toEntity();

      // assert
      expect(result, WeatherSeeds.weatherEntities[0]);
    });
  });
}
