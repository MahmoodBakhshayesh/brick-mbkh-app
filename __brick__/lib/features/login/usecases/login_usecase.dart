import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/login_response.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class LoginRequest extends Request {
  final String phone;
  final String password;

  LoginRequest({required this.phone, required this.password});

  @override
  Failure? validate() => null;
  
  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Request": {
        "PhoneNumber": phone,
        "Password": password
      }
    }
  };
}

class LoginResponse extends UseCaseResponse {
  final bool success;
  final LoginResponseData? loginData;
  final String message;

  LoginResponse({required this.success, this.loginData, this.message = ''});
}

class LoginUsecase extends UseCase<LoginResponse, LoginRequest> {
  final LoginRepository _repository;

  LoginUsecase(this._repository);

  @override
  Future<LoginResponse> exec(LoginRequest request) async {
    return _repository.login(request);
  }
}
