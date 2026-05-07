import 'dart:developer';

import '/features/login/domain/entities/check_phone_response_entity.dart';
import '/features/login/usecases/complete_profile_usecase.dart';
import '/features/login/usecases/confirm_otp_login_usecase.dart';
import '/features/login/usecases/confirm_register_usecase.dart';
import '/features/login/usecases/get_bootstrap_usecase.dart';
import '/features/login/usecases/login_usecase.dart';
import '/features/login/usecases/otp_login_usecase.dart';
import '/features/login/usecases/register_usecase.dart';

import '../../../../core/interfaces/base_data_source.dart';
import '../../usecases/check_phone_usecase.dart';
import '../entities/bootstrap_class.dart';
import '../entities/login_response.dart';
import '../interfaces/login_data_source_interface.dart';

class LoginDataSourceRemote extends RemoteDataSource implements LoginDataSourceInterface {
  LoginDataSourceRemote(super.apiService);

  @override
  Future<UserEntity?> getUserByUsername(String username) {
    // TODO: implement getUserByUsername
    throw UnimplementedError();
  }

  @override
  Future<CheckPhoneResponseData?> checkPhone(CheckPhoneRequest request) async {
    final nr = await apiService.post(
      "Auth/check-phone",
      body: request.toJson()
    );
    if (nr.success) {
      final cpr = CheckPhoneResponseData.fromJson(nr.data["Body"]["Response"]);
      return cpr;
    }
    return null;
  }

  @override
  Future<void> register(RegisterRequest request) async {
    final nr = await apiService.post(
      "Auth/register",
      body:request.toJson()
    );
  }

  @override
  Future<String> confirmRegister(ConfirmRegisterRequest request) async {
    final nr = await apiService.post("Auth/register/confirm",body: request.toJson());
    if (nr.success) {
      final res = nr.data["Body"]["Response"]["AccessToken"];
      return res;
    }
    throw Exception(nr.message);
  }

  @override
  Future<LoginResponseData?> login(LoginRequest request) async {

    final nr = await apiService.post("Auth/login/password",body: request.toJson());
    if (nr.success) {
      final res = LoginResponseData.fromJson(nr.data["Body"]["Response"]);
      return res;
    }
    throw Exception(nr.message);
  }

  @override
  Future<void> completeProfile(CompleteProfileRequest request) async {
    final nr = await apiService.post("Auth/register/complete-profile",body: request.toJson());
    if (nr.success) {
      // final res = UserEntity.fromJson(nr.data["Body"]["Response"]);
      // return res;
      return;
    }
    throw Exception(nr.message);
  }

  @override
  Future<void> otpLogin(OtpLoginRequest request) async {
    final nr = await apiService.post("Auth/login/otp/request",body: request.toJson());
    if (nr.success) {
      return;
    }
    throw Exception(nr.message);
  }

  @override
  Future<LoginResponseData?> confirmOtpLogin(ConfirmOtpLoginRequest request) async {
    final nr = await apiService.post("Auth/login/otp/confirm",body: request.toJson());
    if (nr.success) {
      final res = LoginResponseData.fromJson(nr.data["Body"]["Response"]);
      return res;
    }
    throw Exception(nr.message);
  }

  @override
  Future<Bootstrap?> getBootstrap(GetBootstrapRequest request) async {
    Uri uri = Uri(path: 'Bootstrap',queryParameters: {"version":request.version?.toString()} );
    final nr = await apiService.get(uri.toString());
    if (nr.success) {
      if(nr.data["Body"]["Response"]["Data"] == null && request.cached!=null){
        return request.cached!;
      }
      final res = Bootstrap.fromJson(nr.data["Body"]["Response"]);
      return res;
    }
    throw Exception(nr.message);
  }
}
