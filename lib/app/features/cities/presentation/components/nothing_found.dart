import 'package:flutter/material.dart';

import '../constants/cities_components_constants.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(CitiesComponentsConstants.nothingFoundErrorTitle),
        Text(CitiesComponentsConstants.nothingFoundErrorSubtitle),
      ],
    );
  }
}
