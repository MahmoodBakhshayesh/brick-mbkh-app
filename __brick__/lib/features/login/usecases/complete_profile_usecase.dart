
import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/login_response.dart';
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
  Map<String, dynamic> toJson() => Request.apiEnvelope({
    'Password': password,
    'FullName': fullName,
    'ProfessionType': professionType,
    'ProfessionTitle': professionTitle,
  });
}

class CompleteProfileResponse extends UseCaseResponse {
  final UserEntity? user;

  CompleteProfileResponse({super.success, this.user, super.message, super.error});
}

class CompleteProfileUsecase extends RepositoryVoidUseCase<CompleteProfileResponse, CompleteProfileRequest> {
  final LoginRepository _repository;

  CompleteProfileUsecase(this._repository);

  @override
  Future<CompleteProfileResponse> fetchFromRepository(CompleteProfileRequest request) =>
      _repository.completeProfile(request);
}
