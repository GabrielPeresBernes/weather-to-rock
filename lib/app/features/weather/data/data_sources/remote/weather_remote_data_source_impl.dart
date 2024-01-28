import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../core/infra/network/network.dart';
import '../../models/remote/forecast_remote_model.dart';
import 'weather_remote_data_source.dart';

final class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  const WeatherRemoteDataSourceImpl({
    required this.client,
  });

  final CoreNetwork client;

  @override
  Future<Either<Exception, ForecastRemoteModel>>
      getCurrentWeatherByCoordinates({
    required String lat,
    required String lng,
  }) async {
    try {
      final response = await client.get('/weather', queryParams: {
        "lat": lat,
        "lon": lng,
        "appid": dotenv.env['API_KEY']!,
      });

      return Right(ForecastRemoteModel.fromJson(response));
    } catch (exception) {
      return Left(Exception(exception));
    }
  }

  @override
  Future<Either<Exception, List<ForecastRemoteModel>>>
      getFutureWeatherByCoordinates({
    required String lat,
    required String lng,
  }) async {
    try {
      final response = await client.get('/forecast', queryParams: {
        "lat": lat,
        "lon": lng,
        "appid": dotenv.env['API_KEY']!,
      });

      return Right(List<ForecastRemoteModel>.from(
        response['list'].map((item) => ForecastRemoteModel.fromJson(item)),
      ));
    } catch (exception) {
      return Left(Exception(exception));
    }
  }
}
