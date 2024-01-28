import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/components/card_tile.dart';
import 'package:weather_to_rock/app/components/cloud_icon.dart';
import 'package:weather_to_rock/app/components/error_message.dart';
import 'package:weather_to_rock/app/features/cities/presentation/bloc/cities_bloc.dart';
import 'package:weather_to_rock/app/features/cities/presentation/components/nothing_found.dart';
import 'package:weather_to_rock/app/features/cities/presentation/constants/cities_components_constants.dart';
import 'package:weather_to_rock/app/features/cities/presentation/screens/cities_screen.dart';
import 'package:weather_to_rock/app/features/weather/infra/routes/weather_route.dart';
import 'package:weather_to_rock/app/shared/constants/components_constants.dart';

import '../../../../../mocks/router_mock.dart';
import '../../../../../utils/widget_utils.dart';
import '../../mocks/cities_mocks.dart';
import '../../seeds/cities_seeds.dart';

main() {
  late MockRouter router;
  late CitiesBloc bloc;

  setUp(() {
    router = MockRouter();

    when(() => router.push(any())).thenAnswer((_) async {
      return null;
    });

    bloc = MockCitiesBloc();

    when(() => bloc.state).thenReturn(CitiesSeeds.citiesBlocInitialState);

    when(
      () => bloc.getLocalWeatherNotifier(),
    ).thenReturn(ValueNotifier<Map<String, dynamic>>({}));
  });

  Future<void> buildScreen(WidgetTester tester) async {
    return WidgetUtils.pumpWidget(
      tester,
      widget: const CitiesScreen(),
      router: router,
      providers: [
        BlocProvider<CitiesBloc>(create: (_) => bloc),
      ],
    );
  }

  testWidgets('should show cities when status is success', (tester) async {
    // arrange
    whenListen<CitiesState>(
      bloc,
      Stream.fromIterable(
        const [
          CitiesState(
            cities: CitiesSeeds.citiesEntities,
            status: CitiesStatus.success,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CardTile &&
            widget.title == CitiesSeeds.citiesEntities[0].name &&
            widget.subtitle == CitiesSeeds.citiesEntities[0].country,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CardTile &&
            widget.title == CitiesSeeds.citiesEntities[1].name &&
            widget.subtitle == CitiesSeeds.citiesEntities[1].country,
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'should show cities with cloud icon when status is success and data is cached',
      (tester) async {
    // arrange
    whenListen<CitiesState>(
      bloc,
      Stream.fromIterable(
        const [
          CitiesState(
            cities: CitiesSeeds.citiesEntitiesCached,
            status: CitiesStatus.success,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(find.byType(CardTile), findsNWidgets(2));

    expect(find.byType(CloudIcon), findsNWidgets(2));
  });

  testWidgets('should show loading component when status is loading',
      (tester) async {
    // arrange
    whenListen<CitiesState>(
      bloc,
      Stream.fromIterable(
        const [
          CitiesState(
            cities: CitiesSeeds.citiesEntities,
            status: CitiesStatus.loading,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show empty component when search result is empty',
      (tester) async {
    // arrange
    whenListen<CitiesState>(
      bloc,
      Stream.fromIterable(
        const [
          CitiesState(
            cities: [],
            status: CitiesStatus.empty,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(find.byType(CardTile), findsNothing);

    expect(find.byType(NothingFound), findsOneWidget);

    expect(
      find.text(CitiesComponentsConstants.nothingFoundErrorTitle),
      findsOneWidget,
    );

    expect(
      find.text(CitiesComponentsConstants.nothingFoundErrorSubtitle),
      findsOneWidget,
    );
  });

  testWidgets('should show error component when status is failure',
      (tester) async {
    // arrange
    whenListen<CitiesState>(
      bloc,
      Stream.fromIterable(
        const [
          CitiesState(cities: [], status: CitiesStatus.failure),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(find.byType(ErrorMessage), findsOneWidget);

    expect(find.text(ComponentsConstants.errorMessageTitle), findsOneWidget);

    expect(find.text(ComponentsConstants.errorMessageSubtitle), findsOneWidget);

    expect(find.text(ComponentsConstants.errorMessageButton), findsOneWidget);
  });

  testWidgets('should navigate to weather screen when city is tapped',
      (tester) async {
    // arrange
    whenListen<CitiesState>(
      bloc,
      Stream.fromIterable(
        const [
          CitiesState(
            cities: CitiesSeeds.citiesEntities,
            status: CitiesStatus.success,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // act
    await tester.tap(find.text(CitiesSeeds.citySearch));

    await tester.pumpAndSettle();

    // assert
    verify(
      () => router.push(
        const WeatherRoute().getLocation(
          WeatherRouteParams(
            city: CitiesSeeds.citiesEntities[0].name,
            lat: CitiesSeeds.citiesEntities[0].lat,
            lng: CitiesSeeds.citiesEntities[0].lng,
            slug: CitiesSeeds.citiesEntities[0].slug,
          ),
        ),
      ),
    ).called(1);
  });
}
