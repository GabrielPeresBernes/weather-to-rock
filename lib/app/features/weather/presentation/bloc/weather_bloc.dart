import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_to_rock/core/exceptions/connection_exception.dart';
import 'package:weather_to_rock/app/features/weather/domain/entities/forecast.dart';

import '../../domain/usecases/get_weather_usecase.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required GetWeatherUseCase getWeather,
  })  : _getWeather = getWeather,
        super(const WeatherState()) {
    on<WeatherGetForecast>(_onWeatherGetForecast);
  }

  final GetWeatherUseCase _getWeather;

  Future<void> _onWeatherGetForecast(
    WeatherGetForecast event,
    Emitter<WeatherState> emit,
  ) async {
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );

    final result = await _getWeather(
      GetWeatherParams(
        lat: event.lat ?? '',
        lng: event.lng ?? '',
        slug: event.slug ?? '',
      ),
    );

    emit(
      result.fold(
        (exception) => state.copyWith(
          status: exception is ConnectionException
              ? WeatherStatus.notConnected
              : WeatherStatus.failure,
        ),
        (forecast) => state.copyWith(
          forecast: forecast,
          status: WeatherStatus.success,
        ),
      ),
    );
  }
}
