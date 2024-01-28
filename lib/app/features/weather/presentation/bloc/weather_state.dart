part of 'weather_bloc.dart';

enum WeatherStatus {
  loading,
  success,
  failure,
  notConnected,
}

final class WeatherState extends Equatable {
  const WeatherState({
    this.status = WeatherStatus.loading,
    this.forecast,
  });

  final WeatherStatus status;
  final Forecast? forecast;

  WeatherState copyWith({
    WeatherStatus? status,
    Forecast? forecast,
  }) {
    return WeatherState(
      status: status ?? this.status,
      forecast: forecast ?? this.forecast,
    );
  }

  @override
  List<Object?> get props => [
        status,
        forecast,
      ];
}
