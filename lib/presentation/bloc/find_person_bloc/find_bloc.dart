import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';
import 'package:flutter_clear_arch/domain/interactor/person/find_person.dart';
import 'package:flutter_clear_arch/presentation/bloc/find_person_bloc/find_event.dart';
import 'package:flutter_clear_arch/presentation/bloc/find_person_bloc/find_state.dart';

import 'find_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';
const UNKNOWN_FAILURE_MESSAGE = 'Unknown Failure';

class PersonFindBloc extends Bloc<PersonFindEvent,PersonFindState>{
  final FindPerson findPerson;

  PersonFindBloc({required this.findPerson}) : super(PersonFindEmpty());

  @override
  Stream<PersonFindState> mapEventToState(PersonFindEvent event) async* {
    if (event is FindPersons) {
      yield* _mapFetchPersonsToState(event.personQuery);
    }
  }

  Stream<PersonFindState> _mapFetchPersonsToState(String personQuery) async* {
    yield PersonFindLoading();

    final failureOrPerson = await findPerson(FindPersonParams(query: personQuery));

    yield failureOrPerson.fold(
            (failure) => PersonFindError(message :_mapFailureToMessage(failure)),
            (person) => PersonFindLoaded(persons :person));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      case UnknownFailure:
        return UNKNOWN_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}