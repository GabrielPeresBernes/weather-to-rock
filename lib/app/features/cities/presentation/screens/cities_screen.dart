import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_to_rock/app/components/card_tile.dart';
import 'package:weather_to_rock/app/components/error_message.dart';
import 'package:weather_to_rock/app/features/cities/presentation/components/nothing_found.dart';
import 'package:weather_to_rock/app/features/weather/infra/routes/weather_route.dart';

import '../../../../components/cloud_icon.dart';
import '../../utils/cities_utils.dart';
import '../bloc/cities_bloc.dart';
import '../constants/cities_screen_constants.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CitiesBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(CitiesScreenConstants.screenTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              key: const Key('search_city_text_field'),
              decoration: const InputDecoration(
                labelText: CitiesScreenConstants.searchCityLabel,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => bloc.add(CitiesGet(query: value)),
            ),
            BlocBuilder<CitiesBloc, CitiesState>(
              builder: (context, state) {
                switch (state.status) {
                  case CitiesStatus.loading:
                    {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case CitiesStatus.failure:
                    {
                      return Center(
                        child: ErrorMessage(
                          onRetry: () => bloc.add(const CitiesGet()),
                        ),
                      );
                    }
                  case CitiesStatus.empty:
                    {
                      return const NothingFound();
                    }
                  case CitiesStatus.success:
                    {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.cities.length,
                        itemBuilder: (context, index) {
                          final city = state.cities[index];

                          return CardTile(
                            icon: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  foregroundImage: Svg(city.flag),
                                ),
                                ValueListenableBuilder(
                                  valueListenable:
                                      bloc.getLocalWeatherNotifier(),
                                  builder: (context, value, _) {
                                    return Visibility(
                                      visible: CitiesUtils.isCityWeatherCached(
                                        city: city,
                                        data: value,
                                      ),
                                      child: const CloudIcon(),
                                    );
                                  },
                                ),
                              ],
                            ),
                            subtitle: city.country,
                            title: city.name,
                            onTap: () => context.push(
                              const WeatherRoute().getLocation(
                                WeatherRouteParams(
                                  city: city.name,
                                  lat: city.lat,
                                  lng: city.lng,
                                  slug: city.slug,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
