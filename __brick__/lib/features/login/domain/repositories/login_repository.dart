import 'dart:developer';
import '/core/helpers/error_message_formatter.dart';

import '/features/login/domain/entities/bootstrap_class.dart';
import '/features/login/usecases/check_phone_usecase.dart';
import '/features/login/usecases/complete_profile_usecase.dart';
import '/features/login/usecases/confirm_otp_login_usecase.dart';
import '/features/login/usecases/confirm_register_usecase.dart';
import '/features/login/usecases/get_bootstrap_usecase.dart';
import '/features/login/usecases/otp_login_usecase.dart';
import '/features/login/usecases/register_usecase.dart';
import 'package:get_it/get_it.dart';
import '../../usecases/login_usecase.dart';
import '../data_sources/login_data_source_local.dart';
import '../data_sources/login_data_source_remote.dart';
import '../entities/check_phone_response_entity.dart';
import '../entities/login_response.dart';
import '../interfaces/login_data_source_interface.dart';
import '../interfaces/login_repository_interface.dart';

class LoginRepository implements LoginRepositoryInterface {
  final LoginDataSourceRemote remoteDataSource;
  final LoginDataSourceLocal localDataSource;

  LoginRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  static LoginRepository builder() {
    return LoginRepository(
      remoteDataSource: GetIt.instance.get(instanceName: 'LoginDataSourceRemote'),
      localDataSource: GetIt.instance.get(instanceName: 'LoginDataSourceLocal'),
    );
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final loginData = await remoteDataSource.login(request);
      return LoginResponse(success: true, loginData: loginData);
    } catch (e, st) {
      return LoginResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<UserEntity?> getUserByUsername(String username) {
    return remoteDataSource.getUserByUsername(username);
  }

  @override
  UserEntity? loadLoginResponse() {
    // This should ideally come from the local data source.
    return null;
  }

  @override
  Future<CheckPhoneResponse> checkPhone(CheckPhoneRequest request) async {
    try {
      final data = await remoteDataSource.checkPhone(request);
      return CheckPhoneResponse(success: true, checkPhoneResponseData: data);
    } catch (e, st) {
      if (e is Error) {
        log(e.stackTrace.toString());
      }
      return CheckPhoneResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      await remoteDataSource.register(request);
      return RegisterResponse(success: true);
    } catch (e, st) {
      return RegisterResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<ConfirmRegisterResponse> confirmRegister(ConfirmRegisterRequest request) async {
    try {
      final token = await remoteDataSource.confirmRegister(request);
      return ConfirmRegisterResponse(success: true,token: token);
    } catch (e, st) {
      return ConfirmRegisterResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<CompleteProfileResponse> completeProfile(CompleteProfileRequest request) async {
    try {
      final ue = await remoteDataSource.completeProfile(request);
      return CompleteProfileResponse(success: true, user: null);
    } catch (e, st) {
      if( e is Error){
        log("${e.stackTrace.toString()}");
      }
      return CompleteProfileResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<OtpLoginResponse> otpLogin(OtpLoginRequest request) async {
    try {
      final ue = await remoteDataSource.otpLogin(request);
      return OtpLoginResponse(success: true);
    } catch (e, st) {
      if( e is Error){
        log("${e.stackTrace.toString()}");
      }
      return OtpLoginResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<ConfirmOtpLoginResponse> confirmOtpLogin(ConfirmOtpLoginRequest request) async {
    try {
      final loginData = await remoteDataSource.confirmOtpLogin(request);
      return ConfirmOtpLoginResponse(success: true, loginData: loginData);
    } catch (e, st) {
      if(e is Error){
        log(e.stackTrace.toString());
      }
      return ConfirmOtpLoginResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }

  @override
  Future<GetBootstrapResponse> getBootstrap(GetBootstrapRequest request) async {
    try {
      final bootstrap = await remoteDataSource.getBootstrap(request);
      return GetBootstrapResponse(success: true, bootstrap: bootstrap!);
    } catch (e, st) {
      if(e is Error){
        log(e.stackTrace.toString());
      }
      return GetBootstrapResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }
}
