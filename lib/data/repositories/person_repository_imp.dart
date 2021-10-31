import 'package:dartz/dartz.dart';
import 'package:flutter_clear_arch/data/datasource/person_local_data_source.dart';
import 'package:flutter_clear_arch/data/datasource/person_remote_data_source.dart';
import 'package:flutter_clear_arch/data/models/person_model.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:flutter_clear_arch/domain/exception/exception.dart';
import 'package:flutter_clear_arch/domain/exception/failure.dart';
import 'package:flutter_clear_arch/domain/repositories/device_state_repository.dart';
import 'package:flutter_clear_arch/domain/repositories/person_repository.dart';

class PersonRepositoryImp extends PersonRepository {
  final PersonLocalDataSource localDataSource;
  final PersonRemoteDataSource remoteDataSource;
  final DeviceStateRepository deviceStateRepository;

  PersonRepositoryImp({required this.localDataSource, required this.remoteDataSource,
      required this.deviceStateRepository});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDataSource.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDataSource.searchPerson(query);
    });
  }


  Future<Either<Failure, List<PersonModel>>> _getPersons(
      Future<List<PersonModel>> Function() getPersons) async {
    if(await deviceStateRepository.isNetworkAvailable){
      try{
        final remotePersons = await getPersons();
        localDataSource.personsToCache(remotePersons);
        return Right(remotePersons);
      }catch (e) {
        if(e is ServerException){
          return Left(ServerFailure());
        }else {
          return Left(UnknownFailure());
        }
      }
    }else {
      try {
        final localPerson = await localDataSource.getLastPersonsFromCache();
        return Right(localPerson);
      } catch (e) {
        if(e is CacheException){
          return Left(CacheFailure());
        }else {
          return Left(UnknownFailure());
        }
      }
    }
  }
}
