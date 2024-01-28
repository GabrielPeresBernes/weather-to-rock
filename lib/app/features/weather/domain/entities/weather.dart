import 'package:equatable/equatable.dart';

final class Weather extends Equatable {
  const Weather({
    required this.condition,
    this.date,
  });

  final String condition;
  final String? date;

  @override
  List<Object?> get props => [condition, date];
}
