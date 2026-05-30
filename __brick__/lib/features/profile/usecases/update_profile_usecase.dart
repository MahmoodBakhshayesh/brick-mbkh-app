import 'package:{{project_name}}/features/login/domain/entities/bootstrap_class.dart';
import 'package:{{project_name}}/features/login/domain/entities/login_response.dart';

import '../../../core/interfaces/base_usecase.dart';
import '../../../core/interfaces/base_result.dart';
import '../domain/repositories/profile_repository.dart';

class UpdateProfileRequest extends Request {
  final String fullName;
  final String bio;
  final Profession profession;

  UpdateProfileRequest({required this.fullName, required this.bio,required this.profession});

  @override
  Failure? validate() => null;

  @override
  Map<String, dynamic> toJson() => Request.apiEnvelope({
    'FullName': fullName,
    'Bio': bio,
    'ProfessionTypeId': profession.id,
    'ProfessionTitle': profession.displayName,
  });
}

class UpdateProfileResponse extends UseCaseResponse {
  final UserEntity? profileData;

  UpdateProfileResponse({super.success, this.profileData, super.message, super.error});
}

class UpdateProfileUsecase extends RepositoryUseCase<UserEntity, UpdateProfileResponse, UpdateProfileRequest> {
  final ProfileRepository _repository;

  UpdateProfileUsecase(this._repository);

  @override
  Future<UpdateProfileResponse> fetchFromRepository(UpdateProfileRequest request) =>
      _repository.updateProfile(request);

  @override
  UserEntity? dataFromResponse(UpdateProfileResponse response) => response.profileData;
}
