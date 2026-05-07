import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/check_phone_response_entity.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class OtpLoginRequest extends Request {
  final String phone;

  OtpLoginRequest({required this.phone});

  @override
  Failure? validate() => null;
  
  @override
  Map<String, dynamic> toJson() => {
    "Body": {
      "Request": {"PhoneNumber": phone},
    },
  };
}

class OtpLoginResponse extends UseCaseResponse {
  final bool success;
  final String message;

  OtpLoginResponse({required this.success, this.message = ''});
}

class OtpLoginUsecase extends UseCase<OtpLoginResponse, OtpLoginRequest> {
  final LoginRepository _repository;

  OtpLoginUsecase(this._repository);

  @override
  Future<OtpLoginResponse> exec(OtpLoginRequest request) async {
    return _repository.otpLogin(request);
  }
}
