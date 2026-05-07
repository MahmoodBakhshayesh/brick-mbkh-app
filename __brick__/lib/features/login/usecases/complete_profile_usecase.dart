
import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/login_response.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class CompleteProfileRequest extends Request {
  final String password;
  final String fullName;
  final int professionType;
  final String professionTitle;

  CompleteProfileRequest({
    required this.password,
    required this.fullName,
    required this.professionType,
    required this.professionTitle,
  });

  @override
  Failure? validate() => null;

  @override
  Map<String, dynamic> toJson() => {
    "Body": {
      "Request": {
        "Password": password,
        "FullName": fullName,
        "ProfessionType": professionType,
        "ProfessionTitle": professionTitle,
      },
    },
  };
}

class CompleteProfileResponse extends UseCaseResponse {
  final bool success;
  final UserEntity? user;
  final String message;

  CompleteProfileResponse({required this.success, this.user, this.message = ''});
}

class CompleteProfileUsecase extends UseCase<CompleteProfileResponse, CompleteProfileRequest> {
  final LoginRepository _repository;

  CompleteProfileUsecase(this._repository);

  @override
  Future<CompleteProfileResponse> exec(CompleteProfileRequest request) async {
    return _repository.completeProfile(request);
  }
}
