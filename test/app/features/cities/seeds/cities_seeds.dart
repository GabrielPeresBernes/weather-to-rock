import 'package:weather_to_rock/app/features/cities/data/models/city_model.dart';
import 'package:weather_to_rock/app/features/cities/domain/entities/city.dart';
import 'package:weather_to_rock/app/features/cities/presentation/bloc/cities_bloc.dart';

abstract final class CitiesSeeds {
  static const List<CityModel> citiesModels = [
    CityModel(
      slug: 'sp',
      name: 'São Paulo',
      country: 'Brazil',
      flag: 'assets/icons/flags/br.svg',
      lat: '-23.5506507',
      lng: '-46.6333824',
    ),
    CityModel(
      slug: 'mb',
      name: 'Melbourne',
      country: 'Australia',
      flag: 'assets/icons/flags/au.svg',
      lat: '-37.8142176',
      lng: '144.9631608',
    ),
  ];

  static const List<City> citiesEntities = [
    City(
      slug: 'sp',
      name: 'São Paulo',
      country: 'Brazil',
      flag: 'assets/icons/flags/br.svg',
      lat: '-23.5506507',
      lng: '-46.6333824',
    ),
    City(
      slug: 'mb',
      name: 'Melbourne',
      country: 'Australia',
      flag: 'assets/icons/flags/au.svg',
      lat: '-37.8142176',
      lng: '144.9631608',
    ),
  ];

  static const List<City> citiesEntitiesCached = [
    City(
      slug: 'sp',
      name: 'São Paulo',
      country: 'Brazil',
      flag: 'assets/icons/flags/br.svg',
      lat: '-23.5506507',
      lng: '-46.6333824',
      isCached: true,
    ),
    City(
      slug: 'mb',
      name: 'Melbourne',
      country: 'Australia',
      flag: 'assets/icons/flags/au.svg',
      lat: '-37.8142176',
      lng: '144.9631608',
      isCached: true,
    ),
  ];

  static const String citySearch = 'São Paulo';

  static const CitiesState citiesBlocInitialState = CitiesState(
    cities: [],
    status: CitiesStatus.loading,
  );
}
