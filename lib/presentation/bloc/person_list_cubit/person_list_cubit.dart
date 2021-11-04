import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';
import 'package:flutter_clear_arch/domain/interactor/person/get_persons.dart';
import 'package:flutter_clear_arch/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:meta/meta.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';
const UNKNOWN_FAILURE_MESSAGE = 'Unknown Failure';

class PersonListCubit extends Cubit<PersonState> {
  final GetPersons getPersons;

  PersonListCubit({required this.getPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity>[];
    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final personOrFailure = await getPersons(PagePersonParams(page: page));

    personOrFailure.fold(
            (error) => emit(PersonError(message: _mapFailureToMessage(error))),
            (character) {
              page++;
              final persons = (state as PersonLoading).oldPersonsList;
              persons.addAll(character);
              print('List length: ${persons.length.toString()}');
              emit(PersonLoaded(persons));
            });
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