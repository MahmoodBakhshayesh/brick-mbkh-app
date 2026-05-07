import 'dart:developer';

import '/core/data/app_data.dart';
import '/features/login/domain/entities/bootstrap_class.dart';
import '/features/login/login_controller.dart';
import '/widgets/app_field_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../widgets/buttons/app_new_button.dart';
import '../../../widgets/inputs/app_text_form_field.dart';
import '../../../widgets/main_card.dart';

class CompleteProfileWidget extends HookConsumerWidget {
  final String phone;

  const CompleteProfileWidget({super.key, required this.phone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider);
    final nameC = useTextEditingController();
    final passC = useTextEditingController();
    final profession = useState<Profession?>(null);
    final validData = useState(false);

    useEffect(() {
      void listener() {
        validData.value = nameC.text.isNotEmpty && passC.text.isNotEmpty && profession.value != null;
      }
      nameC.addListener(listener);
      passC.addListener(listener);
      validData.addListener(listener);

      return () {
        nameC.removeListener(listener);
        passC.removeListener(listener);
        validData.removeListener(listener);
      };
    }, [nameC, profession, passC]);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 56),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            context.localizations.completeProfile,
            style: AppStyles.pageHeader,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            context.localizations.welcome,
            style: AppStyles.cardHeader,
          ),
        ),
        MainCard(
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localizations.insertYourName,
                style: AppStyles.cardHeader,
              ),
              AppTextFormField(
                placeholder: context.localizations.name,
                controller: nameC,
              ),
              SizedBox(),
              Text(
                context.localizations.insertYourPass,
                style: AppStyles.cardHeader,
              ),
              AppTextFormField(
                placeholder: context.localizations.password,
                controller: passC,
                isPassword: true,
              ),
              SizedBox(),
              AppFieldPicker<Profession>(
                label: context.localizations.insertYourProfession,
                labelStyle: AppStyles.cardHeader,
                items: AppData.instance.bootstrapData?.professions ?? [],
                value: profession.value,
                height: 75,
                onChange: (p) {
                  profession.value = p;
                },
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
          child: AppNewButton(
            label: context.localizations.submit,
            onPressed: () async {
              await loginController.completeProfile(phone: phone, password: passC.text, name: nameC.text);
            },
            disabled: !validData.value,
            icon: Icons.check,
            color: AppColors.actions,
          ),
        ),
      ],
    );
  }
}
