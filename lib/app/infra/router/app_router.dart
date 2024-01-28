import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_to_rock/app/features/cities/infra/routes/cities_route.dart';
import 'package:weather_to_rock/app/features/weather/infra/routes/weather_route.dart';
import 'package:weather_to_rock/app/features/weather/presentation/bloc/weather_bloc.dart';

import '../../features/cities/presentation/bloc/cities_bloc.dart';

final class AppRouter {
  const AppRouter();

  final CitiesRoute _citiesRoute = const CitiesRoute();
  final WeatherRoute _weatherRoute = const WeatherRoute();

  GoRouter router() {
    return GoRouter(
      initialLocation: _citiesRoute.path,
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) {
            return BlocProvider(
              create: (_) => GetIt.I.get<CitiesBloc>()..add(const CitiesGet()),
              child: _citiesRoute.build(),
            );
          },
          routes: [
            GoRoute(
              path: _weatherRoute.path,
              builder: (_, state) {
                final city = state.uri.queryParameters['city'];
                final lat = state.uri.queryParameters['lat'];
                final lng = state.uri.queryParameters['lng'];
                final slug = state.uri.queryParameters['slug'];

                return BlocProvider(
                  create: (_) => GetIt.I.get<WeatherBloc>()
                    ..add(
                      WeatherGetForecast(lat: lat, lng: lng, slug: slug),
                    ),
                  child: _weatherRoute.build(
                    WeatherRouteParams(
                      city: city,
                      lat: lat,
                      lng: lng,
                      slug: slug,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
