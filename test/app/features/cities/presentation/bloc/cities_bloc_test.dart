import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/cities/domain/entities/city.dart';
import 'package:weather_to_rock/app/features/cities/domain/usecases/get_cities_usecase.dart';
import 'package:weather_to_rock/app/features/cities/presentation/bloc/cities_bloc.dart';
import 'package:weather_to_rock/app/shared/constants/app_constants.dart';
import 'package:weather_to_rock/core/infra/local_storage/core_local_storage.dart';

import '../../mocks/cities_mocks.dart';
import '../../seeds/cities_seeds.dart';

main() {
  late GetCitiesUseCase getCities;
  late CoreLocalStorage localStorage;

  setUpAll(() {
    registerFallbackValue(FakeGetCitiesParams());
  });

  setUp(() {
    getCities = MockGetCitiesUseCase();
    localStorage = MockCoreLocalStorage();
  });

  CitiesBloc buildBloc() {
    return CitiesBloc(
      getCities: getCities,
      localStorage: localStorage,
    );
  }

  group('cities_bloc', () {
    blocTest<CitiesBloc, CitiesState>(
      'emits empty state when usecase returns empty list',
      setUp: () {
        when(() => getCities(any()))
            .thenAnswer((_) async => const Right(<City>[]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitiesGet(query: 'empty')),
      expect: () => const [
        CitiesState(cities: [], status: CitiesStatus.loading),
        CitiesState(cities: [], status: CitiesStatus.empty),
      ],
      verify: (bloc) {
        verify(() => getCities(const GetCitiesParams(query: 'empty')))
            .called(1);
      },
    );

    blocTest<CitiesBloc, CitiesState>(
      'emits success state when usecase returns list with cities',
      setUp: () {
        when(() => getCities(any()))
            .thenAnswer((_) async => const Right(CitiesSeeds.citiesEntities));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitiesGet()),
      expect: () => const [
        CitiesState(cities: [], status: CitiesStatus.loading),
        CitiesState(
          cities: CitiesSeeds.citiesEntities,
          status: CitiesStatus.success,
        ),
      ],
      verify: (bloc) {
        verify(() => getCities(const GetCitiesParams())).called(1);
      },
    );

    blocTest<CitiesBloc, CitiesState>(
      'emits error state when usecase returns error',
      setUp: () {
        when(() => getCities(any())).thenAnswer((_) async => Left(Exception()));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitiesGet()),
      expect: () => const [
        CitiesState(cities: [], status: CitiesStatus.loading),
        CitiesState(cities: [], status: CitiesStatus.failure),
      ],
      verify: (bloc) {
        verify(() => getCities(const GetCitiesParams())).called(1);
      },
    );

    test('should get local weather notifier from local storage', () async {
      // arrange
      when(
        () => localStorage.getNotifier<Map<String, dynamic>>(
          AppConstants.localDataWeatherKey,
          {},
        ),
      ).thenReturn(ValueNotifier<Map<String, dynamic>>({}));

      final bloc = buildBloc();

      // act
      final notifier = bloc.getLocalWeatherNotifier();

      // assert
      verify(
        () => localStorage.getNotifier<Map<String, dynamic>>(
          AppConstants.localDataWeatherKey,
          {},
        ),
      ).called(1);

      expect(notifier, isA<ValueNotifier<Map<String, dynamic>>>());
    });
  });
}
