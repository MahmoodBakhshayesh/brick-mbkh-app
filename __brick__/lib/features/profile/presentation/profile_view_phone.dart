import '/core/data/app_data.dart';
import '/features/login/domain/entities/login_response.dart';
import '/features/login/login_view_state.dart';
import '/features/profile/widgets/user_avatar.dart';
import '/widgets/app_field_picker.dart';
import '/widgets/app_lang_widget.dart';
import '/widgets/app_text_field.dart';
import '/widgets/dot_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../widgets/buttons/app_button.dart';
import '../profile_controller.dart';
import '../../../core/extensions/context_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileViewPhone extends HookConsumerWidget {
  const ProfileViewPhone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileController = ref.watch(profileControllerProvider);
    final UserEntity? user = ref.watch(authenticatedUserProvider);

    final editMode = useState(false);
    if (user == null) {
      return Scaffold();
    }
    final nameC = useTextEditingController.fromValue(TextEditingValue(text: user.fullName));
    final bioC = useTextEditingController.fromValue(TextEditingValue(text: user.bio??''));
    final profession = useState(AppData.instance.bootstrapData!.professions.firstWhere((a) => a.id == user.professionType));
    return Scaffold(
      appBar: ProfileAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: UserAvatar(
                    url: user.profileImageUrl,
                    size: context.width * 0.5,
                    onChange: profileController.setAvatar,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localizations.bio,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.bio??'',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(user.phoneNumber),
              leading: Icon(Icons.phone),
            ),
            editMode.value
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AppTextFieldNew(
                            label: context.localizations.name,
                            controller: nameC,
                          ),
                          AppFieldPicker(
                            label: context.localizations.profession,
                            items: AppData.instance.bootstrapData!.professions,
                            value: profession.value,
                            onChange: (a) {
                              profession.value = a!;
                            },
                          ),
                          AppTextFieldNew(
                            height: 120,
                            label: context.localizations.bio,
                            minLines: 3,
                            maxLines: 5,
                            controller: bioC,
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(user.fullName),
                          leading: Icon(Icons.person),
                        ),
                        ListTile(
                          title: Text(user.professionTitle),
                          leading: Icon(Icons.star),
                        ),
                      ],
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: !editMode.value
                  ? Row(
                      spacing: 8,
                      children: [
                        DotButton(
                          size: 40,
                          icon: Icons.edit,
                          onPressed: () {
                            editMode.value = true;
                          },
                        ),
                        // Expanded(
                        //   child:  AppSliderButton(
                        //     color: AppColors.ice,
                        //     label: 'slider to exit',
                        //     icon: Icons.exit_to_app,
                        //     onPressed: () async {
                        //       await Future.delayed(Duration(seconds: 1));
                        //       // await profileController.logout(context);
                        //     },
                        //   ),
                        // ),
                        Expanded(
                          child: AppButton(
                            label: context.localizations.logout,
                            onPressed: () {},
                            onLongPress: () async {
                              await profileController.logout(context);
                            },
                          ),
                        ),
                      ],
                    )
                  :
              Row(
                children: [
                  Expanded(
                          child: AppButton(
                            label: context.localizations.confirm,
                            onPressed: () async {
                              final update = await profileController.updateProfile(fullName: nameC.text, bio: bioC.text, profession: profession.value);
                              if (update) {
                                editMode.value = false;
                              }
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(108);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: context.mainColor,
      alignment: Alignment.center,
      child: SafeArea(
        child: Row(
          children: [
            BackButton(
              color: Colors.white,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          context.localizations.profile,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ),

                      AppLangWidget(),
                      SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
