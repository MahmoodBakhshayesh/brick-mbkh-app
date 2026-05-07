import '/features/login/domain/entities/login_response.dart';
import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/bootstrap_class.dart';
import '../domain/interfaces/login_repository_interface.dart';
import '../domain/repositories/login_repository.dart';

class GetBootstrapRequest extends Request {
  final int? version;
  final Bootstrap? cached;

  GetBootstrapRequest({required this.version,required this.cached});

  @override
  Failure? validate() => null;

  @override
  Map<String, dynamic> toJson() => {
    "Body": {
      "Request": {
        "ID": version,
      },
    },
  };
}

class GetBootstrapResponse extends UseCaseResponse {
  final bool success;
  final Bootstrap? bootstrap;
  final String message;

  GetBootstrapResponse({required this.success, this.bootstrap, this.message = ''});
}

class GetBootstrapUsecase extends UseCase<GetBootstrapResponse, GetBootstrapRequest> {
  final LoginRepository _repository;

  GetBootstrapUsecase(this._repository);

  @override
  Future<GetBootstrapResponse> exec(GetBootstrapRequest request) async {
    return _repository.getBootstrap(request);
  }
}
