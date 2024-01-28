import 'package:equatable/equatable.dart';

final class City extends Equatable {
  const City({
    required this.flag,
    required this.name,
    required this.country,
    required this.lat,
    required this.lng,
    required this.slug,
    this.isCached = false,
  });

  final String flag;
  final String name;
  final String country;
  final String lat;
  final String lng;
  final String slug;
  final bool isCached;

  @override
  List<Object?> get props => [
        flag,
        name,
        country,
        lat,
        lng,
        slug,
        isCached,
      ];
}
