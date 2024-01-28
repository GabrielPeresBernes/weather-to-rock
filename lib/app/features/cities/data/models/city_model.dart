import 'package:equatable/equatable.dart';

import '../../domain/entities/city.dart';

class CityModel extends Equatable {
  const CityModel({
    required this.slug,
    required this.flag,
    required this.name,
    required this.country,
    required this.lat,
    required this.lng,
  });

  final String slug;
  final String flag;
  final String name;
  final String country;
  final String lat;
  final String lng;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        flag: json["flag"],
        name: json["name"],
        country: json["country"],
        lat: json["lat"],
        lng: json["lng"],
        slug: json["slug"],
      );

  City toEntity() => City(
        flag: flag,
        name: name,
        country: country,
        lat: lat,
        lng: lng,
        slug: slug,
      );

  @override
  List<Object?> get props => [slug, flag, name, country, lat, lng];
}
