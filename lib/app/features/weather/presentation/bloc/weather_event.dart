part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherGetForecast extends WeatherEvent {
  const WeatherGetForecast({
    required this.lat,
    required this.lng,
    required this.slug,
  });

  final String? lat;
  final String? lng;
  final String? slug;

  @override
  List<Object?> get props => [lat, lng, slug];
}
