import 'package:dartz/dartz.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
}