import 'package:flutter_clear_arch/data/datasource/person_local_data_source.dart';
import 'package:flutter_clear_arch/data/datasource/person_remote_data_source.dart';
import 'package:flutter_clear_arch/data/repositories/device_state_repository_imp.dart';
import 'package:flutter_clear_arch/data/repositories/person_repository_imp.dart';
import 'package:flutter_clear_arch/domain/interactor/person/find_person.dart';
import 'package:flutter_clear_arch/domain/interactor/person/get_persons.dart';
import 'package:flutter_clear_arch/domain/repositories/device_state_repository.dart';
import 'package:flutter_clear_arch/domain/repositories/person_repository.dart';
import 'package:flutter_clear_arch/presentation/bloc/find_person_bloc/find_bloc.dart';
import 'package:flutter_clear_arch/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;


Future<void> init() async {
// BLoC / Cubit
  sl.registerFactory(
        () => PersonListCubit(getPersons: sl()),
  );
  sl.registerFactory(
        () => PersonFindBloc(findPerson: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetPersons(sl()));
  sl.registerLazySingleton(() => FindPerson(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(
        () => PersonRepositoryImp(
      remoteDataSource: sl(),
      localDataSource: sl(),
      deviceStateRepository: sl(),
    ),
  );

  sl.registerLazySingleton<PersonRemoteDataSource>(
        () => PersonRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<PersonLocalDataSource>(
        () => PersonLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<DeviceStateRepository>(
        () => DeviceStateRepositoryImp(sl()),
  );

  // External
  final  sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
