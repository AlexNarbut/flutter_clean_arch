import 'package:dartz/dartz.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}