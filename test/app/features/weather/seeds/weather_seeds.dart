import 'package:weather_to_rock/app/features/cities/domain/entities/city.dart';
import 'package:weather_to_rock/app/features/weather/data/models/local/forecast_local_model.dart';
import 'package:weather_to_rock/app/features/weather/data/models/local/weather_local_model.dart';
import 'package:weather_to_rock/app/features/weather/data/models/remote/forecast_remote_model.dart';
import 'package:weather_to_rock/app/features/weather/data/models/remote/weather_remote_model.dart';
import 'package:weather_to_rock/app/features/weather/domain/entities/forecast.dart';
import 'package:weather_to_rock/app/features/weather/domain/entities/weather.dart';

abstract final class WeatherSeeds {
  static List<WeatherLocalModel> weatherLocalModels = [
    const WeatherLocalModel(condition: 'Clear', date: null),
    const WeatherLocalModel(condition: 'Clouds', date: 'Aug 23 - 00:00'),
    const WeatherLocalModel(condition: 'Rain', date: 'Aug 24 - 00:00'),
  ];

  static const List<WeatherRemoteModel> weatherRemoteModels = [
    WeatherRemoteModel(condition: 'Clear'),
    WeatherRemoteModel(condition: 'Clouds'),
    WeatherRemoteModel(condition: 'Rain'),
  ];

  static final ForecastLocalModel forecastLocalModel = ForecastLocalModel(
    current: WeatherSeeds.weatherLocalModels[0],
    futures: [
      WeatherSeeds.weatherLocalModels[1],
      WeatherSeeds.weatherLocalModels[2],
    ],
  );

  static List<ForecastRemoteModel> forecastRemoteModelFutures = [
    ForecastRemoteModel(
      weather: [WeatherSeeds.weatherRemoteModels[1]],
      date: '2017-08-23 00:00:00',
    ),
    ForecastRemoteModel(
      weather: [WeatherSeeds.weatherRemoteModels[2]],
      date: '2017-08-24 00:00:00',
    ),
  ];

  static ForecastRemoteModel forecastRemoteModelCurrent = ForecastRemoteModel(
    weather: [WeatherSeeds.weatherRemoteModels[0]],
    date: null,
  );

  static List<Weather> weatherEntities = [
    const Weather(condition: 'Clear', date: null),
    const Weather(condition: 'Clouds', date: 'Aug 23 - 00:00'),
    const Weather(condition: 'Rain', date: 'Aug 24 - 00:00'),
  ];

  static final Forecast forecastEntity = Forecast(
    current: WeatherSeeds.weatherEntities[0],
    futures: [
      WeatherSeeds.weatherEntities[1],
      WeatherSeeds.weatherEntities[2],
    ],
  );

  static const City cityEntity = City(
    slug: 'sp',
    name: 'São Paulo',
    country: 'Brazil',
    flag: 'assets/icons/flags/br.svg',
    lat: '-23.5506507',
    lng: '-46.6333824',
  );
}
