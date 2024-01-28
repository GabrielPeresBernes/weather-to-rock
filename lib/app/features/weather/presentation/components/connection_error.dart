import 'package:flutter/material.dart';

import '../constants/weather_components_constants.dart';

class ConnectionError extends StatelessWidget {
  const ConnectionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Column(
        children: [
          Text(WeatherComponentsConstants.connectionErrorTitle),
          Text(
            WeatherComponentsConstants.connectionErrorSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
