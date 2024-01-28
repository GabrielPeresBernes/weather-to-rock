import 'package:flutter_test/flutter_test.dart';
import 'package:weather_to_rock/app/features/cities/data/data_sources/local/cities_local_data_source_impl.dart';

import '../../../../../../utils/fixtures_utils.dart';
import '../../../seeds/cities_seeds.dart';

void main() {
  group('cities_local_data_source_impl', () {
    test('should return cities when query input is empty', () async {
      // arrange
      final localData = FixturesUtils.readFixture('cities/cities.json');

      // act
      final result =
          await CitiesLocalDataSourceImpl(localData: localData).getCities(null);

      final cities = result.getOrElse(() => throw Exception());

      // assert
      expect(result.isRight(), true);

      expect(cities, CitiesSeeds.citiesModels);
    });

    test('should return cities when query input is provided', () async {
      // arrange
      final localData = FixturesUtils.readFixture('cities/cities.json');

      // act
      final result =
          await CitiesLocalDataSourceImpl(localData: localData).getCities(
        CitiesSeeds.citySearch,
      );

      final cities = result.getOrElse(() => throw Exception());

      // assert
      expect(result.isRight(), true);

      expect(cities, [CitiesSeeds.citiesModels[0]]);
    });

    test('should return exception when local data is invalid', () async {
      // arrange
      const localData = 'invalid';

      // act
      final result = await const CitiesLocalDataSourceImpl(localData: localData)
          .getCities(null);

      // assert
      expect(result.isLeft(), true);
    });
  });
}
