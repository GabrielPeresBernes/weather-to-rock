import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/weather.dart';

class WeatherRemoteModel extends Equatable {
  const WeatherRemoteModel({
    required this.condition,
  });

  factory WeatherRemoteModel.fromJson(Map<String, dynamic> json) =>
      WeatherRemoteModel(
        condition: json["main"],
      );

  Weather toEntity([String? date]) => Weather(
        condition: condition,
        date: date != null
            ? DateFormat("MMM d - HH:mm").format(DateTime.parse(date))
            : null,
      );

  final String condition;

  @override
  List<Object?> get props => [condition];
}
