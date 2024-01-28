import 'package:flutter/material.dart';

import '../../../../../core/interfaces/core_route.dart';
import '../../presentation/screens/weather_screen.dart';

final class WeatherRoute implements CoreRoute<WeatherRouteParams> {
  const WeatherRoute();

  @override
  String get path => 'weather';

  @override
  String getLocation([params]) => Uri(
        path: '/weather',
        queryParameters: {
          'city': params?.city,
          'lat': params?.lat,
          'lng': params?.lng,
          'slug': params?.slug,
        },
      ).toString();

  @override
  Widget build([params]) => WeatherScreen(
        city: params?.city,
        lat: params?.lat,
        lng: params?.lng,
        slug: params?.slug,
      );
}

final class WeatherRouteParams {
  const WeatherRouteParams({
    required this.city,
    required this.lat,
    required this.lng,
    required this.slug,
  });

  final String? city;
  final String? lat;
  final String? lng;
  final String? slug;
}
