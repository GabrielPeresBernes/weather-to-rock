part of 'cities_bloc.dart';

enum CitiesStatus {
  loading,
  success,
  failure,
  empty,
}

class CitiesState extends Equatable {
  const CitiesState({
    this.status = CitiesStatus.loading,
    this.cities = const [],
  });

  final CitiesStatus status;
  final List<City> cities;

  CitiesState copyWith({
    CitiesStatus? status,
    List<City>? cities,
  }) {
    return CitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
    );
  }

  @override
  List<Object?> get props => [status, cities];
}
