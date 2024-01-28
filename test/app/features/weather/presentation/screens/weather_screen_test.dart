import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/components/card_tile.dart';
import 'package:weather_to_rock/app/components/error_message.dart';
import 'package:weather_to_rock/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_to_rock/app/features/weather/presentation/components/connection_error.dart';
import 'package:weather_to_rock/app/features/weather/presentation/constants/weather_components_constants.dart';
import 'package:weather_to_rock/app/features/weather/presentation/constants/weather_screen_constants.dart';
import 'package:weather_to_rock/app/features/weather/presentation/screens/weather_screen.dart';
import 'package:weather_to_rock/app/shared/constants/components_constants.dart';

import '../../../../../mocks/router_mock.dart';
import '../../../../../utils/widget_utils.dart';
import '../../mocks/weather_mocks.dart';
import '../../seeds/weather_seeds.dart';

main() {
  late MockRouter router;
  late WeatherBloc bloc;

  setUp(() {
    router = MockRouter();

    when(() => router.push(any())).thenAnswer((_) async => null);

    bloc = MockWeatherBloc();

    when(() => bloc.state).thenReturn(
      const WeatherState(status: WeatherStatus.loading),
    );
  });

  Future<void> buildScreen(WidgetTester tester) async {
    return WidgetUtils.pumpWidget(
      tester,
      widget: const WeatherScreen(),
      router: router,
      providers: [
        BlocProvider<WeatherBloc>(create: (_) => bloc),
      ],
    );
  }

  testWidgets('should show weather forecast when status is success',
      (tester) async {
    // arrange
    whenListen<WeatherState>(
      bloc,
      Stream.fromIterable(
        [
          WeatherState(
            forecast: WeatherSeeds.forecastEntity,
            status: WeatherStatus.success,
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
            widget.title == WeatherSeeds.forecastEntity.current.condition &&
            widget.subtitle == WeatherScreenConstants.nowSubtitle,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CardTile &&
            widget.title == WeatherSeeds.forecastEntity.futures[0].condition &&
            widget.subtitle == WeatherSeeds.forecastEntity.futures[0].date,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CardTile &&
            widget.title == WeatherSeeds.forecastEntity.futures[1].condition &&
            widget.subtitle == WeatherSeeds.forecastEntity.futures[1].date,
      ),
      findsOneWidget,
    );
  });

  testWidgets('should show loading component when status is loading',
      (tester) async {
    // arrange
    whenListen<WeatherState>(
      bloc,
      Stream.fromIterable(
        [
          const WeatherState(
            status: WeatherStatus.loading,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'should show connection error component when status is notConnected',
      (tester) async {
    // arrange
    whenListen<WeatherState>(
      bloc,
      Stream.fromIterable(
        const [
          WeatherState(
            status: WeatherStatus.notConnected,
          ),
        ],
      ),
    );

    await buildScreen(tester);

    // assert
    expect(find.byType(ConnectionError), findsOneWidget);

    expect(
      find.text(WeatherComponentsConstants.connectionErrorTitle),
      findsOneWidget,
    );

    expect(
      find.text(WeatherComponentsConstants.connectionErrorSubtitle),
      findsOneWidget,
    );
  });

  testWidgets('should show error component when status is failure',
      (tester) async {
    // arrange
    whenListen<WeatherState>(
      bloc,
      Stream.fromIterable(
        const [
          WeatherState(
            status: WeatherStatus.failure,
          ),
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
}
