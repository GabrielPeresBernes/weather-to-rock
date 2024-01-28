import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_to_rock/core/infra/local_storage/core_local_storage.dart';
import 'package:weather_to_rock/app/features/cities/domain/entities/city.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../domain/usecases/get_cities_usecase.dart';

part 'cities_event.dart';
part 'cities_state.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  CitiesBloc({
    required GetCitiesUseCase getCities,
    required CoreLocalStorage localStorage,
  })  : _getCities = getCities,
        _localStorage = localStorage,
        super(const CitiesState()) {
    on<CitiesGet>(_onCitiesGet);
  }

  final GetCitiesUseCase _getCities;
  final CoreLocalStorage _localStorage;

  ValueNotifier<Map<String, dynamic>> getLocalWeatherNotifier() {
    return _localStorage.getNotifier<Map<String, dynamic>>(
      AppConstants.localDataWeatherKey,
      {},
    );
  }

  Future<void> _onCitiesGet(
    CitiesGet event,
    Emitter<CitiesState> emit,
  ) async {
    emit(
      state.copyWith(
        cities: const [],
        status: CitiesStatus.loading,
      ),
    );

    final result = await _getCities(
      GetCitiesParams(query: event.query),
    );

    emit(
      result.fold(
        (exception) => state.copyWith(
          status: CitiesStatus.failure,
        ),
        (cities) => state.copyWith(
          cities: cities,
          status: cities.isEmpty ? CitiesStatus.empty : CitiesStatus.success,
        ),
      ),
    );
  }
}
