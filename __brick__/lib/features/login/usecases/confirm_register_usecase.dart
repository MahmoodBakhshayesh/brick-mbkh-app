import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/login_response.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class ConfirmRegisterRequest extends Request {
  final String phone;
  final String code;

  ConfirmRegisterRequest({
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

class ConfirmRegisterResponse extends UseCaseResponse {
  final bool success;
  final String? token;
  final String message;

  ConfirmRegisterResponse({required this.success, this.token, this.message = ''});
}

class ConfirmRegisterUsecase extends UseCase<ConfirmRegisterResponse, ConfirmRegisterRequest> {
  final LoginRepository _repository;

  ConfirmRegisterUsecase(this._repository);

  @override
  Future<ConfirmRegisterResponse> exec(ConfirmRegisterRequest request) async {
    return _repository.confirmRegister(request);
  }
}
