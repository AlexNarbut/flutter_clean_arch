import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';
import 'package:flutter_clear_arch/domain/interactor/base/usecase.dart';
import 'package:flutter_clear_arch/domain/repositories/person_repository.dart';
import 'package:meta/meta.dart';

class GetPersons extends UseCase<List<PersonEntity>, PagePersonParams> {
  final PersonRepository personRepository;

  GetPersons(this.personRepository);

  Future<Either<Failure, List<PersonEntity>>> call(PagePersonParams params) async {
    return await personRepository.getAllPersons(params.page);
  }
}

class PagePersonParams extends Equatable {
  final int page;

  PagePersonParams({required this.page});

  @override
  List<Object> get props => [page];
}