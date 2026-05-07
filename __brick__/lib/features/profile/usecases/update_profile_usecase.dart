import '/features/login/domain/entities/bootstrap_class.dart';
import '/features/login/domain/entities/login_response.dart';

import '../../../core/interfaces/base_usecase.dart';
import '../../../core/interfaces/base_result.dart';
import '../domain/interfaces/profile_repository_interface.dart';
import '../domain/repositories/profile_repository.dart';

class UpdateProfileRequest extends Request {
  final String fullName;
  final String bio;
  final Profession profession;

  UpdateProfileRequest({required this.fullName, required this.bio,required this.profession});

  @override
  Failure? validate() => null;

  @override
  Map<String, dynamic> toJson() => {
    "Body": {
      "Request": {
        "FullName": fullName,
        "Bio": bio,
        "ProfessionTypeId": profession.id,
        "ProfessionTitle": profession.displayName,
      },
    },
  };
}

class UpdateProfileResponse extends UseCaseResponse {
  final bool success;
  final UserEntity? profileData;
  final String message;

  UpdateProfileResponse({required this.success, this.profileData, this.message = ''});
}

class UpdateProfileUsecase extends UseCase<UpdateProfileResponse, UpdateProfileRequest> {
  final ProfileRepository _repository;

  UpdateProfileUsecase(this._repository);

  @override
  Future<UpdateProfileResponse> exec(UpdateProfileRequest request) async {
    return _repository.updateProfile(request);
  }
}
