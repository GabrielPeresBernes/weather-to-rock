import 'package:flutter_test/flutter_test.dart';
import 'package:weather_to_rock/app/features/weather/data/models/remote/weather_remote_model.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../seeds/weather_seeds.dart';

void main() {
  group('weather_remote_model', () {
    test('should return a valid model from JSON', () {
      // arrange
      final json = FixturesUtils.readFixtureAsMap(
          'weather/weather_remote.json')['weather'][0];

      // act
      final result = WeatherRemoteModel.fromJson(json);

      // assert
      expect(result, WeatherSeeds.weatherRemoteModels[0]);
    });

    test('should map to a valid Entity', () {
      // arrange
      final json = FixturesUtils.readFixtureAsMap(
          'weather/weather_remote.json')['weather'][0];

      // act
      final model = WeatherRemoteModel.fromJson(json);

      final result = model.toEntity();

      // assert
      expect(result, WeatherSeeds.weatherEntities[0]);
    });
  });
}
