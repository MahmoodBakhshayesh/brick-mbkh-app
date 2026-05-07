import 'dart:developer';
import '/core/helpers/error_message_formatter.dart';

import '/features/profile/domain/data_sources/profile_data_source_local.dart';
import '/features/profile/domain/data_sources/profile_data_source_remote.dart';

import '../../usecases/update_profile_usecase.dart';
import '../interfaces/profile_repository_interface.dart';
import '../interfaces/profile_data_source_interface.dart';
import 'package:get_it/get_it.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final ProfileDataSourceRemote remoteDataSource;
  final ProfileDataSourceLocal localDataSource;

  ProfileRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  static ProfileRepository builder() {
    return ProfileRepository(
      remoteDataSource: GetIt.instance.get(instanceName: 'ProfileDataSourceRemote'),
      localDataSource: GetIt.instance.get(instanceName: 'ProfileDataSourceLocal'),
    );
  }

  @override
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final profile = await remoteDataSource.updateProfile(request);
      return UpdateProfileResponse(success: true, profileData: profile!);
    } catch (e, st) {
      return UpdateProfileResponse(success: false, message: ErrorMessageFormatter.format(e, st));
    }
  }
}
