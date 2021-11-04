import 'package:equatable/equatable.dart';

abstract class PersonFindEvent extends Equatable {
  const PersonFindEvent();

  @override
  List<Object> get props => [];
}

class FindPersons extends PersonFindEvent {
  final String personQuery;

  FindPersons(this.personQuery);

}