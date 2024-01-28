import 'package:flutter/material.dart';
import 'package:weather_to_rock/app/features/cities/presentation/screens/cities_screen.dart';

import '../../../../../core/interfaces/core_route.dart';

final class CitiesRoute implements CoreRoute<void> {
  const CitiesRoute();

  @override
  String get path => '/';

  @override
  String getLocation([params]) => '/';

  @override
  Widget build([params]) => const CitiesScreen();
}
