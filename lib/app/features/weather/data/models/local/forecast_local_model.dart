import 'package:equatable/equatable.dart';

import '../../../domain/entities/forecast.dart';
import '../../../domain/entities/weather.dart';
import 'weather_local_model.dart';

class ForecastLocalModel extends Equatable {
  const ForecastLocalModel({
    required this.current,
    required this.futures,
  });

  factory ForecastLocalModel.fromJson(Map<String, dynamic> json) =>
      ForecastLocalModel(
        current: WeatherLocalModel.fromJson(json["current"]),
        futures: List<WeatherLocalModel>.from(
          json["futures"].map(
            (data) => WeatherLocalModel.fromJson(data),
          ),
        ),
      );

  factory ForecastLocalModel.fromEntity(Forecast forecast) =>
      ForecastLocalModel(
        current: WeatherLocalModel.fromEntity(forecast.current),
        futures: List<WeatherLocalModel>.from(
          forecast.futures.map(
            (data) => WeatherLocalModel.fromEntity(data),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "current": current.toJson(),
        "futures": List<dynamic>.from(
          futures.map(
            (data) => data.toJson(),
          ),
        ),
      };

  Forecast toEntity() => Forecast(
        current: current.toEntity(),
        futures: List<Weather>.from(
          futures.map(
            (data) => data.toEntity(),
          ),
        ),
      );

  final WeatherLocalModel current;
  final List<WeatherLocalModel> futures;

  @override
  List<Object?> get props => [current, futures];
}
