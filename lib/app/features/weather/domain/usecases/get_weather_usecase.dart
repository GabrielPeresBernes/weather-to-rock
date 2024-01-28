import 'package:equatable/equatable.dart';
import 'package:weather_to_rock/app/features/weather/domain/entities/forecast.dart';

import '../../../../../core/interfaces/use_case.dart';
import '../repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

/// Gets weather forecast by city
class GetWeatherUseCase implements UseCase<Forecast, GetWeatherParams> {
  const GetWeatherUseCase({
    required this.weatherRepository,
  });

  final WeatherRepository weatherRepository;

  @override
  Future<Either<Exception, Forecast>> call(GetWeatherParams params) async {
    return weatherRepository.getWetherForecastByCity(
      lat: params.lat,
      lng: params.lng,
      slug: params.slug,
    );
  }
}

class GetWeatherParams extends Equatable {
  const GetWeatherParams({
    required this.lat,
    required this.lng,
    required this.slug,
  });

  final String lat;
  final String lng;
  final String slug;

  @override
  List<Object?> get props => [lat, lng, slug];
}
