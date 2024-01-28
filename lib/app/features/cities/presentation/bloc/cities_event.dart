part of 'cities_bloc.dart';

sealed class CitiesEvent extends Equatable {
  const CitiesEvent();

  @override
  List<Object?> get props => [];
}

final class CitiesGet extends CitiesEvent {
  const CitiesGet({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}
