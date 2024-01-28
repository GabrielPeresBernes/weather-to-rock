import 'package:flutter_test/flutter_test.dart';
import 'package:weather_to_rock/app/features/cities/data/models/city_model.dart';

import '../../../../../utils/fixtures_utils.dart';
import '../../seeds/cities_seeds.dart';

void main() {
  group('city_model', () {
    test('should return a valid model from JSON', () {
      final json =
          FixturesUtils.readFixtureAsMap('cities/cities.json')['cities']![0];

      // act
      final result = CityModel.fromJson(json);

      // assert
      expect(result, CitiesSeeds.citiesModels[0]);
    });

    test('should map to a valid entity', () {
      // arrange
      final json =
          FixturesUtils.readFixtureAsMap('cities/cities.json')['cities']![0];

      // act
      final result = CityModel.fromJson(json);

      // assert
      expect(result.toEntity(), CitiesSeeds.citiesEntities[0]);
    });
  });
}
