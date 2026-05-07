import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '/core/interfaces/base_failure.dart';
import '/core/interfaces/base_result.dart';
import '/di.dart';
import '/features/login/usecases/check_phone_usecase.dart';
import '/features/login/usecases/complete_profile_usecase.dart';
import '/features/login/usecases/confirm_register_usecase.dart';
import '/features/login/usecases/get_bootstrap_usecase.dart';
import '/features/login/usecases/otp_login_usecase.dart';
import '/features/login/usecases/register_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../core/controllers/base_controller.dart';
import '../../core/data/app_data.dart';
import 'domain/entities/bootstrap_class.dart';
import 'domain/entities/login_response.dart';
import 'login_view_state.dart';
import 'usecases/confirm_otp_login_usecase.dart';
import 'usecases/login_usecase.dart';

final loginControllerProvider = Provider.autoDispose((ref) {
  final loginUsecase = GetIt.instance.get<LoginUsecase>();
  final controller = LoginController(ref, loginUsecase);
  Future.microtask(controller.init);
  ref.onDispose(() => controller.dispose());
  return controller;
});

class LoginController extends BaseController {
  final LoginUsecase _loginUsecase;

  LoginController(super.ref, this._loginUsecase);

  @override
  void init() {
    loadBootstrap(null);
    super.init();
  }

  Future<void> login(String username, String password) async {
    logger.i("Attempting login for user: '$username'");
    ref.read(loginErrorMessageProvider.notifier).state = null;
    ref.read(loginIsLoadingProvider.notifier).state = true;

    try {
      final request = LoginRequest(phone: username, password: password);
      final loginResponse = await _loginUsecase.exec(request);

      if (loginResponse.success) {
        loginWithResponse(loginResponse.loginData!,null);
      } else {
        logger.w("Login failed for user: '$username'. Reason: ${loginResponse.message}");

        FailureBus.I.emit(FailureNotice(failure: ServerFailure(loginResponse.message)));
        ref.read(loginErrorMessageProvider.notifier).state = loginResponse.message;
      }
    } catch (e, st) {
      logger.e("An exception occurred during login for user: '$username'", error: e, stackTrace: st);
      ref.read(loginErrorMessageProvider.notifier).state = e.toString();
    } finally {
      ref.read(loginIsLoadingProvider.notifier).state = false;
    }
  }

  Future<void> checkPhone(String phone) async {
    final checkPhoneUsecase = GetIt.instance.get<CheckPhoneUsecase>();
    final checkPhoneResponse = await checkPhoneUsecase.exec(CheckPhoneRequest(phone: phone));
    if (checkPhoneResponse.success) {
      logger.i("Login successful for user: '${checkPhoneResponse.checkPhoneResponseData!.exists}'");
      logger.i(jsonEncode(checkPhoneResponse.checkPhoneResponseData!.toJson()));
      final data = checkPhoneResponse.checkPhoneResponseData!;
      if (data.exists) {
        if (data.requiresRegistration) {
          ref.read(signupStepProvider.notifier).update((s) => 2);
          sendSMS(phone);
        } else {
          // if(data.canLoginWithPassword){
          if (!data.isProfileCompleted) {
            // ref.read(signupStepProvider.notifier).update((s)=>3);
            ref.read(signupStepProvider.notifier).update((s) => 2);
            sendSMS(phone);
          } else {
            ref.read(signupStepProvider.notifier).update((s) => 4);
          }

          // }else if(data.canLoginWithOtp){
          //   ref.read(signupStepProvider.notifier).update((s)=>5);
          // }
        }
      } else {
        ref.read(signupStepProvider.notifier).update((s) => 2);
        sendSMS(phone);
        // ref.read(signupStepProvider.notifier).update((s) => 1);
      }
    } else {
      FailureBus.I.emitMsg(checkPhoneResponse.message);
      logger.e("error -> ${checkPhoneResponse.message}");
    }
  }

  Future<void> checkUser() async {
    // logger.e("checkUser");
    // ref.read(checkingUserProvider.notifier).update((s) => true);
    final sp = await sharedPreferencesAsync;
    // String? bootstrapJson = sp.getString("Bootstrap");
    // if (bootstrapJson == null) {
    //   return;
    // }
    // Bootstrap bootstrap = Bootstrap.fromJson(jsonDecode(bootstrapJson));
    // AppData.instance.setBootstrap(bootstrap);
    String? userJson = sp.getString("User");
    if (userJson == null) {
      return;
    }

    LoginResponseData loginData = LoginResponseData.fromJson(jsonDecode(userJson));
    loginWithResponse(loginData,null);
    // await goEcips();

    // Future.delayed(const Duration(seconds: 1), () {
    //   ref.read(checkingUserProvider.notifier).update((s) => false);
    // });
  }

  Future<void> confirmRegister(String phone, String code) async {
    final confirmRegisterUsecase = GetIt.instance.get<ConfirmRegisterUsecase>();
    final confirmRegisterResponse = await confirmRegisterUsecase.exec(ConfirmRegisterRequest(phone: phone, code: code));
    if (confirmRegisterResponse.success) {
      logger.i("User Confrimed'");
      AppData.instance.setToken(confirmRegisterResponse.token!);
      ref.read(signupStepProvider.notifier).update((s) => 3);
    } else {
      FailureBus.I.emitMsg(confirmRegisterResponse.message);
    }
  }

  listenForCode() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // OTPInteractor _otpInteractor = OTPInteractor();
      // final appSignature = await _otpInteractor.getAppSignature();
      //
      // if (kDebugMode) {
      //   logger.e('Your app signature: $appSignature');
      // }
      // late OTPTextEditController controller =
      //     OTPTextEditController(
      //       codeLength: 5,
      //       //ignore: avoid_print
      //       onCodeReceive: (code) => logger.w('Your Application receive code - $code'),
      //       otpInteractor: _otpInteractor,
      //     )..startListenUserConsent(
      //       (code) {
      //         final exp = RegExp(r'(\d{5})');
      //         return exp.stringMatch(code ?? '') ?? '';
      //       },
      //       strategies: [
      //         // SampleStrategy(),
      //       ],
      //     );

      // final sms = await SmsAutoFill().listenForCode();

      getSmsReadPermission().then((v) {
        if (v) {
          final _plugin = Readsms();
          _plugin.read();
          _plugin.smsStream.listen((event) {
            String? extractedCode = extractCodeFromMessage(event.body);
            if (extractedCode == null) {
              return;
            } else {
              ref.read(receivedCodeProvider.notifier).update((s) => extractedCode);
              _plugin.dispose();
            }
          });
        }
      });
    }
  }

  Future<bool> getSmsReadPermission() async {
    // return true;
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  String? extractCodeFromMessage(String message) {
    // Regular expression to match a 5-digit code
    if (!message.toLowerCase().contains("blucher.coffee".toLowerCase())) {
      return null;
    }
    final RegExp codeRegExp = RegExp(r'\b\d{6}\b');
    final match = codeRegExp.firstMatch(message);
    if (match != null) {
      return match.group(0); // Return the matched code
    }
    return null; // Return null if no code is found
  }

  Future<void> sendSMS(String phone) async {
    final registerUsecase = GetIt.instance.get<RegisterUsecase>();
    final registerResponse = await registerUsecase.exec(RegisterRequest(phone: phone));
    if (registerResponse.success) {
      logger.i("User Register Done'");
      ref.read(signupStepProvider.notifier).update((s) => 2);
      listenForCode();
    } else {
      FailureBus.I.emitMsg(registerResponse.message);
    }
  }

  Future<void> loginWithResponse(LoginResponseData loginData,Bootstrap? bs) async {
    ref.read(authenticatedUserProvider.notifier).state = loginData.user;

    // final bootstrap =bs?? await loadBootstrap(null);
    // if (bootstrap == null) return;

    AppData.instance.setUserId(loginData.user.id);
    AppData.instance.setToken(loginData.accessToken);
    final sp = await sharedPreferencesAsync;
    await sp.setString("User", jsonEncode(loginData.toJson()));
    // await sp.setString("Bootstrap", jsonEncode(bootstrap.toJson()));
    ref.read(signupStepProvider.notifier).update((s) => 0);
  }

  Future<Bootstrap?> loadBootstrap(int? version) async {
    final sp = await sharedPreferencesAsync;
    String? bootstrapJson = sp.getString("Bootstrap");
    if (bootstrapJson != null ) {
      Bootstrap bootstrap = Bootstrap.fromJson(jsonDecode(bootstrapJson));
      if(version == null || bootstrap.appConfig.bootstrapVersion == version){
        AppData.instance.setBootstrap(bootstrap);
        await sp.setString("Bootstrap", jsonEncode(bootstrap.toJson()));
        getBootstrap(bootstrap.appConfig.bootstrapVersion,bootstrap);
        return bootstrap;
      }
    }
    final newBT = await getBootstrap(version,null);
    return newBT;
  }
  Future<Bootstrap?> getBootstrap(int? version,Bootstrap? cached) async {
    final sp = await sharedPreferencesAsync;
    final getBootstrapUsecase = locator<GetBootstrapUsecase>();
    final getBootstrapResponse = await getBootstrapUsecase.exec(GetBootstrapRequest(version: version, cached: cached));
    if (getBootstrapResponse.success) {
      AppData.instance.setBootstrap(getBootstrapResponse.bootstrap);
      await sp.setString("Bootstrap", jsonEncode(getBootstrapResponse.bootstrap!.toJson()));
      return getBootstrapResponse.bootstrap;
    }
    return null;
  }

  Future<void> completeProfile({required String phone, required String password, required String name}) async {
    try {
      logger.e("completeProfile");
      final completeProfileUsecase = locator<CompleteProfileUsecase>();
      final completeProfileResponse = await completeProfileUsecase.exec(CompleteProfileRequest(password: password, fullName: name, professionType: 100, professionTitle: 'Developer'));
      if (completeProfileResponse.success) {
        await login(phone, password);
      } else {
        FailureBus.I.emitMsg(completeProfileResponse.message);
      }
    } catch (e) {
      if (e is Error) {
        logger.e(e.stackTrace.toString());
      }
    }
  }

  requestOtpLogin(String phone) async {
    final otpLoginUsecase = locator<OtpLoginUsecase>();
    final otpLoginResponse = await otpLoginUsecase.exec(OtpLoginRequest(phone: phone));
    if (otpLoginResponse.success) {
      listenForCode();
    }
  }

  Future<void> otpLogin(String phone) async {
    ref.read(signupStepProvider.notifier).update((s) => 5);
    await requestOtpLogin(phone);
  }

  Future<void> confirmOtpLogin(String phone, String code) async {
    final confirmOtpLoginUsecase = locator<ConfirmOtpLoginUsecase>();
    final confirmOtpLoginResponse = await confirmOtpLoginUsecase.exec(ConfirmOtpLoginRequest(phone: phone, code: code));
    if (confirmOtpLoginResponse.success) {
      loginWithResponse(confirmOtpLoginResponse.loginData!,null);
    } else {
      FailureBus.I.emit(FailureNotice(failure: ServerFailure(confirmOtpLoginResponse.message)));
      ref.read(loginErrorMessageProvider.notifier).state = confirmOtpLoginResponse.message;
    }
  }
}
