import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/login_response.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class ConfirmOtpLoginRequest extends Request {
  final String phone;
  final String code;

  ConfirmOtpLoginRequest({
    required this.phone,
    required this.code,
  });

  @override
  Failure? validate() => null;

  @override
  Map<String, dynamic> toJson() => {
    "Body": {
      "Request": {
        "PhoneNumber": phone,
        "Code": code,
      },
    },
  };
}

class ConfirmOtpLoginResponse extends UseCaseResponse {
  final bool success;
  final LoginResponseData? loginData;
  final String message;

  ConfirmOtpLoginResponse({required this.success, this.loginData, this.message = ''});
}

class ConfirmOtpLoginUsecase extends UseCase<ConfirmOtpLoginResponse, ConfirmOtpLoginRequest> {
  final LoginRepository _repository;

  ConfirmOtpLoginUsecase(this._repository);

  @override
  Future<ConfirmOtpLoginResponse> exec(ConfirmOtpLoginRequest request) async {
    return _repository.confirmOtpLogin(request);
  }
}
