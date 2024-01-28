import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:weather_to_rock/app/components/card_tile.dart';
import 'package:weather_to_rock/app/components/error_message.dart';
import 'package:weather_to_rock/app/features/weather/presentation/components/connection_error.dart';

import '../../utils/weather_utils.dart';
import '../bloc/weather_bloc.dart';
import '../constants/weather_screen_constants.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({
    super.key,
    this.city,
    this.lat,
    this.lng,
    this.slug,
  });

  final String? city;
  final String? lat;
  final String? lng;
  final String? slug;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WeatherBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(WeatherScreenConstants.screenTitle),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            switch (state.status) {
              case WeatherStatus.loading:
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              case WeatherStatus.failure:
                {
                  return Center(
                    child: ErrorMessage(
                      onRetry: () => bloc.add(
                        WeatherGetForecast(
                          lat: lat,
                          lng: lng,
                          slug: slug,
                        ),
                      ),
                    ),
                  );
                }
              case WeatherStatus.notConnected:
                {
                  return const Center(
                    child: ConnectionError(),
                  );
                }
              case WeatherStatus.success:
                {
                  return Column(
                    children: [
                      Text(city ?? ''),
                      CardTile(
                        icon: SizedBox(
                          width: 60,
                          child: Image(
                            image: Svg(
                              WeatherUtils.getWeatherIcon(
                                state.forecast?.current.condition,
                              ),
                            ),
                          ),
                        ),
                        title: state.forecast?.current.condition ?? '',
                        subtitle: WeatherScreenConstants.nowSubtitle,
                      ),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.forecast?.futures.length,
                        itemBuilder: (context, index) {
                          final forecast = state.forecast?.futures[index];

                          return CardTile(
                            icon: SizedBox(
                              width: 60,
                              child: Image(
                                image: Svg(
                                  WeatherUtils.getWeatherIcon(
                                    forecast?.condition,
                                  ),
                                ),
                              ),
                            ),
                            title: forecast?.condition ?? '',
                            subtitle: forecast?.date ?? '',
                          );
                        },
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
