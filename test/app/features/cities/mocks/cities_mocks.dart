import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_to_rock/app/features/cities/data/data_sources/local/cities_local_data_source.dart';
import 'package:weather_to_rock/app/features/cities/domain/repositories/cities_repository.dart';
import 'package:weather_to_rock/app/features/cities/domain/usecases/get_cities_usecase.dart';
import 'package:weather_to_rock/app/features/cities/presentation/bloc/cities_bloc.dart';
import 'package:weather_to_rock/app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_to_rock/core/infra/local_storage/local_storage.dart';

class FakeGetCitiesParams extends Fake implements GetCitiesParams {}

class MockCitiesLocalDataSource extends Mock implements CitiesLocalDataSource {}

class MockCitiesRepository extends Mock implements CitiesRepository {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockGetCitiesUseCase extends Mock implements GetCitiesUseCase {}

class MockCoreLocalStorage extends Mock implements CoreLocalStorage {}

class MockCitiesBloc extends MockBloc<CitiesEvent, CitiesState>
    implements CitiesBloc {}
