import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/check_phone_response_entity.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class CheckPhoneRequest extends Request {
  final String phone;

  CheckPhoneRequest({required this.phone});

  @override
  Failure? validate() => null;
  
  @override
  Map<String, dynamic> toJson() => {
    "Body": {
      "Request": {"PhoneNumber": phone},
    },
  };
}

class CheckPhoneResponse extends UseCaseResponse {
  final bool success;
  final CheckPhoneResponseData? checkPhoneResponseData;
  final String message;

  CheckPhoneResponse({required this.success, this.checkPhoneResponseData, this.message = ''});
}

class CheckPhoneUsecase extends UseCase<CheckPhoneResponse, CheckPhoneRequest> {
  final LoginRepository _repository;

  CheckPhoneUsecase(this._repository);

  @override
  Future<CheckPhoneResponse> exec(CheckPhoneRequest request) async {
    return _repository.checkPhone(request);
  }
}
