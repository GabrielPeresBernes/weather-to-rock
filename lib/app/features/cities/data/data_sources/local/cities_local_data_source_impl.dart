import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart';

import '../../models/city_model.dart';
import 'cities_local_data_source.dart';

final class CitiesLocalDataSourceImpl implements CitiesLocalDataSource {
  const CitiesLocalDataSourceImpl({this.localData});

  final String? localData;

  @override
  Future<Either<Exception, List<CityModel>>> getCities(String? query) async {
    try {
      final json = localData ?? await rootBundle.loadString('data/cities.json');

      final data = jsonDecode(json) as Map<String, dynamic>;

      final cities = data['cities'] as List;

      final models = cities.map((city) => CityModel.fromJson(city)).toList();

      return Right(_filteredCities(models, query));
    } catch (exception) {
      return Left(Exception(exception));
    }
  }

  List<CityModel> _filteredCities(List<CityModel> cities, String? query) {
    if (query == null || query.isEmpty) {
      return cities;
    }

    String normalizedQuery =
        removeDiacritics(query).toLowerCase().replaceAll(' ', '');

    return cities.where((city) {
      String normalizedCity =
          removeDiacritics(city.name).toLowerCase().replaceAll(' ', '');

      return normalizedCity.contains(normalizedQuery);
    }).toList();
  }
}
