import 'package:equatable/equatable.dart';

import 'weather.dart';

final class Forecast extends Equatable {
  const Forecast({
    required this.current,
    required this.futures,
  });

  final Weather current;
  final List<Weather> futures;

  @override
  List<Object?> get props => [current, futures];
}
