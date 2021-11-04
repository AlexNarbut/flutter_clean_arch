import 'package:equatable/equatable.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:meta/meta.dart';

abstract class PersonFindState extends Equatable {
  const PersonFindState();

  @override
  List<Object> get props => [];
}

class PersonFindEmpty extends PersonFindState {}

class PersonFindLoading extends PersonFindState {}

class PersonFindLoaded extends PersonFindState {
  final List<PersonEntity> persons;

  PersonFindLoaded({required this.persons});

  @override
  List<Object> get props => [persons];
}

class PersonFindError extends PersonFindState {
  final String message;

  PersonFindError({required this.message});

  @override
  List<Object> get props => [message];
}