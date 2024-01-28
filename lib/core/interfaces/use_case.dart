import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract interface class UseCase<Response, Params> {
  Future<Either<Exception, Response>> call(Params params);
}

final class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
