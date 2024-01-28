import 'package:flutter_test/flutter_test.dart';
import 'package:weather_to_rock/app/features/weather/data/models/remote/forecast_remote_model.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../seeds/weather_seeds.dart';

void main() {
  group('forecast_remote_model', () {
    test('should return a valid model from JSON', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_remote.json');

      // act
      final result = ForecastRemoteModel.fromJson(json);

      // assert
      expect(result, WeatherSeeds.forecastRemoteModelCurrent);
    });

    test('should map to a valid Entity', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('weather/weather_remote.json');

      // act
      final model = ForecastRemoteModel.fromJson(json);

      final result = model.toEntity();

      // assert
      expect(result, WeatherSeeds.weatherEntities[0]);
    });
  });
}
