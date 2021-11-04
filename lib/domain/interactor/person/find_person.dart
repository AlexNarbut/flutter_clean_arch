import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';
import 'package:flutter_clear_arch/domain/interactor/base/usecase.dart';
import 'package:flutter_clear_arch/domain/repositories/person_repository.dart';
import 'package:meta/meta.dart';

class FindPerson extends UseCase<List<PersonEntity>, FindPersonParams> {
  final PersonRepository personRepository;

  FindPerson(this.personRepository);

  Future<Either<Failure, List<PersonEntity>>> call(FindPersonParams params) async {
    return await personRepository.searchPerson(params.query);
  }
}

class FindPersonParams extends Equatable {
  final String query;

  FindPersonParams({required this.query});

  @override
  List<Object> get props => [query];
}