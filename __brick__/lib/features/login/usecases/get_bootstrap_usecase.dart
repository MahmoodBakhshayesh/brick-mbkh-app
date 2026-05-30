import '../../../core/interfaces/base_result.dart';
import '../../../core/interfaces/base_usecase.dart';
import '../domain/entities/bootstrap_class.dart';
import '../domain/repositories/login_repository.dart';

class GetBootstrapRequest extends Request {
  final int? version;
  final Bootstrap? cached;

  GetBootstrapRequest({required this.version,required this.cached});

  @override
  Failure? validate() => null;

  @override
  Map<String, dynamic> toJson() => Request.apiEnvelope({'ID': version});
}

class GetBootstrapResponse extends UseCaseResponse {
  final Bootstrap? bootstrap;

  GetBootstrapResponse({super.success, this.bootstrap, super.message, super.error});
}

class GetBootstrapUsecase extends RepositoryUseCase<Bootstrap, GetBootstrapResponse, GetBootstrapRequest> {
  final LoginRepository _repository;

  GetBootstrapUsecase(this._repository);

  @override
  Future<GetBootstrapResponse> fetchFromRepository(GetBootstrapRequest request) =>
      _repository.getBootstrap(request);

  @override
  Bootstrap? dataFromResponse(GetBootstrapResponse response) => response.bootstrap;
}
