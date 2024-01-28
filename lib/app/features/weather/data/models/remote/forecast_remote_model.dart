import 'package:equatable/equatable.dart';

import '../../../domain/entities/weather.dart';
import 'weather_remote_model.dart';

class ForecastRemoteModel extends Equatable {
  const ForecastRemoteModel({
    required this.weather,
    required this.date,
  });

  factory ForecastRemoteModel.fromJson(Map<String, dynamic> json) =>
      ForecastRemoteModel(
        weather: List<WeatherRemoteModel>.from(
          json["weather"].map(
            (data) => WeatherRemoteModel.fromJson(data),
          ),
        ),
        date: json["dt_txt"],
      );

  Weather toEntity() => weather.first.toEntity(date);

  final List<WeatherRemoteModel> weather;
  final String? date;

  @override
  List<Object?> get props => [weather, date];
}
