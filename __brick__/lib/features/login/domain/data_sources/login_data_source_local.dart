import '/features/login/domain/entities/check_phone_response_entity.dart';
import '/features/login/usecases/complete_profile_usecase.dart';
import '/features/login/usecases/confirm_otp_login_usecase.dart';
import '/features/login/usecases/confirm_register_usecase.dart';
import '/features/login/usecases/get_bootstrap_usecase.dart';
import '/features/login/usecases/login_usecase.dart';
import '/features/login/usecases/otp_login_usecase.dart';
import '/features/login/usecases/register_usecase.dart';
import 'package:sembast/sembast.dart';

import '../../../../core/database/sembast.dart';
import '../../../../core/interfaces/base_data_source.dart';
import '../../usecases/check_phone_usecase.dart';
import '../entities/bootstrap_class.dart';
import '../entities/login_response.dart';
import '../interfaces/login_data_source_interface.dart';

class LoginDataSourceLocal extends LocalDataSource implements LoginDataSourceInterface {
  LoginDataSourceLocal(super.keyValueStore);

  @override
  Future<UserEntity?> getUserByUsername(String username) async {
    var finder = Finder(
        filter: Filter.equals('username', username),
        sortOrders: [SortOrder('name')]);

    var records = await SemBastDB.usersTable.find(SemBastDB.instance.db, finder: finder);
    if(records.isEmpty){
      return null;
    }else{
      return UserEntity.fromJson(records.first.value);
    }
  }

  @override
  Future<CheckPhoneResponseData?> checkPhone(CheckPhoneRequest phone)async {
    // TODO: implement checkPhone
    throw UnimplementedError();
  }

  @override
  Future<void> register(RegisterRequest request) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<String?> confirmRegister(ConfirmRegisterRequest request) {
    // TODO: implement confirmRegister
    throw UnimplementedError();
  }

  @override
  Future<LoginResponseData?> login(LoginRequest request) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> completeProfile(CompleteProfileRequest request) {
    // TODO: implement completeProfile
    throw UnimplementedError();
  }

  @override
  Future<void> otpLogin(OtpLoginRequest request) {
    // TODO: implement otpLogin
    throw UnimplementedError();
  }

  @override
  Future<LoginResponseData?> confirmOtpLogin(ConfirmOtpLoginRequest request) {
    // TODO: implement confirmOtpLogin
    throw UnimplementedError();
  }

  @override
  Future<Bootstrap?> getBootstrap(GetBootstrapRequest request) {
    // TODO: implement getBootstrap
    throw UnimplementedError();
  }
}