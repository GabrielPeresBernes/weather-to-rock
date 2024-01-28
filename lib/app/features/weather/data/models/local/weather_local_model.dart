import 'package:equatable/equatable.dart';

import '../../../domain/entities/weather.dart';

class WeatherLocalModel extends Equatable {
  const WeatherLocalModel({
    required this.condition,
    this.date,
  });

  factory WeatherLocalModel.fromJson(Map<String, dynamic> json) =>
      WeatherLocalModel(
        condition: json["condition"],
        date: json["date"],
      );

  factory WeatherLocalModel.fromEntity(Weather weather) => WeatherLocalModel(
        condition: weather.condition,
        date: weather.date,
      );

  Map<String, dynamic> toJson() => {
        "condition": condition,
        "date": date,
      };

  Weather toEntity() => Weather(
        condition: condition,
        date: date,
      );

  final String condition;
  final String? date;

  @override
  List<Object?> get props => [condition, date];
}
