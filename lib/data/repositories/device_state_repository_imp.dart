import 'package:flutter_clear_arch/domain/repositories/device_state_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DeviceStateRepositoryImp implements DeviceStateRepository {
  final InternetConnectionChecker connectionChecker;

  DeviceStateRepositoryImp(this.connectionChecker);

  @override
    Future<bool> get isNetworkAvailable => connectionChecker.hasConnection;

}