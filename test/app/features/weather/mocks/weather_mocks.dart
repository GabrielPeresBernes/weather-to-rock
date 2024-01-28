import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/local/weather_local_data_source.dart';
import 'package:weather_to_rock/app/features/weather/data/data_sources/remote/weather_remote_data_source.dart';
import 'package:weather_to_rock/app/features/weather/data/models/local/forecast_local_model.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_to_rock/app/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:weather_to_rock/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_to_rock/core/infra/local_storage/core_local_storage.dart';
import 'package:weather_to_rock/core/infra/network/network.dart';

class FakeForecastLocalModel extends Fake implements ForecastLocalModel {}

class FakeGetWeatherParams extends Fake implements GetWeatherParams {}

class MockLocalStorage extends Mock implements CoreLocalStorage {}

class MockNetwork extends Mock implements CoreNetwork {}

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

class MockConnectivity extends Mock implements Connectivity {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockGetWeatherUseCase extends Mock implements GetWeatherUseCase {}

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}
