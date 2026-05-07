import 'dart:convert';

import '/core/constants/apis.dart';
import '/core/data/app_data.dart';
import '/core/helpers/nullable.dart';
import '/core/interfaces/base_failure.dart';
import '/features/login/domain/entities/bootstrap_class.dart';
import '/features/login/domain/entities/login_response.dart';
import '/features/login/login_view_state.dart';
import '/features/profile/profile_state.dart';
import '/features/profile/usecases/update_profile_usecase.dart';
import 'package:dio/dio.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/controllers/base_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../di.dart';

final profileControllerProvider = Provider.autoDispose((ref) {
  final controller = ProfileController(ref);
  Future.microtask(controller.init);
  ref.onDispose(() => controller.dispose());
  return controller;
});

class ProfileController extends BaseController {
  ProfileController(super.ref);

  Future<void> logout(BuildContext context) async {
    final sp = await sharedPreferencesAsync;
    await sp.remove("User");
    AppData.instance.setToken(null);
    AppData.instance.setUserId(null);
    // AppData.instance.setBootstrap(null);
    Future.delayed(Duration(milliseconds: 400), () {
      ref.read(authenticatedUserProvider.notifier).update((s) => null);
    });
  }

  Future<bool> updateProfile({required String fullName, required String bio, required Profession profession}) async {
    final updateProfileUsecase = locator<UpdateProfileUsecase>();
    final updateProfileResponse = await updateProfileUsecase.exec(UpdateProfileRequest(fullName: fullName, bio: bio, profession: profession));
    if (updateProfileResponse.success) {
      final updated = updateProfileResponse.profileData!;
      ref.read(authenticatedUserProvider.notifier).update((s)=>updated);
      updateUserInCache(userEntity: updated);
      return true;
    } else {
      FailureBus.I.emitMsg(updateProfileResponse.message);
      return false;
    }
  }

  Future<void> setAvatar(String? current) async {
    var updatingAvatarPN = ref.read(settingAvatarProvider.notifier);
    try {
      updatingAvatarPN.update((state) => true);
      final ImagePicker picker = ImagePicker();
      picker.supportsImageSource(ImageSource.gallery);
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, requestFullMetadata: false, imageQuality: 20);
      if (image == null) {
        updatingAvatarPN.update((state) => false);
        return;
      }
      int imageSize = await image.length();

      final kb = imageSize / 1024;
      final mb = kb / 1024;
      if (mb > 5) {
        FailureBus.I.emitMsg("Image Size is more than 5mb!\nUse smaller image.");
        updatingAvatarPN.update((state) => false);
        return;
      }
      await uploadImage(image);
      if (current != null) {
        await evictImage(current);
      }
      updatingAvatarPN.update((state) => false);
      return;
    } catch (e) {
      updatingAvatarPN.update((state) => false);
    }
  }

  Future<void> evictImage(String current) async {
    logger.i("evict image $current");
    await FastCachedImageConfig.deleteCachedImage(imageUrl: current);
    final NetworkImage provider = NetworkImage(current);
    await provider.evict();
  }

  Future<void> uploadImage(XFile imageFile) async {
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', 'jpg'), // Or 'image', 'webp', etc.
      ),
    });

    String apiAddress = "${Apis.baseUrl}users/me/files/profile-image";
    logger.w("uploading image $fileName to $apiAddress \n ${AppData.instance.token}");
    try {
      final dio = Dio(BaseOptions(receiveTimeout: Duration(minutes: 10), sendTimeout: Duration(minutes: 10), connectTimeout: Duration(minutes: 10)));
      final response = await dio.post(
        apiAddress,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data', "Authorization": "Bearer ${AppData.instance.token}"}),
      );

      if (response.statusCode == 200) {
        logger.w('Upload success: ${response.data}');
        final String fileUrl = response.data["Body"]["Response"]["FileUrl"];
        ref.read(authenticatedUserProvider.notifier).update((s) => s?.copyWith(profileImageUrl: Nullable(fileUrl)));
        updateUserInCache(userEntity: ref.read(authenticatedUserProvider)!);
      }
    } catch (e) {
      logger.w('Upload failed: $e');
      FailureBus.I.emitMsg(e.toString());
    }
  }

  Future<void> updateUserInCache({String? token, UserEntity? userEntity}) async {
    final sp = await sharedPreferencesAsync;
    LoginResponseData loginResponseData = LoginResponseData(accessToken: token ?? AppData.instance.token!, user: userEntity ?? ref.read(authenticatedUserProvider)!);
    logger.w("saveing user ing cache ${loginResponseData.toJson()}");
    await sp.setString("User", jsonEncode(loginResponseData.toJson()));
  }
}
