import '/features/login/widgets/InitialCheckPhoneWidget.dart';
import '/features/login/widgets/complete_profile_widget.dart';
import '/features/login/widgets/confirm_active_code_widget.dart';
import '/features/login/widgets/login_with_otp_widget.dart';
import '/features/login/widgets/login_with_password_widget.dart';
import '/features/login/widgets/send_code_widget.dart';
import '/widgets/app_lang_widget.dart';
import '/widgets/inputs/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/hooks/use_interval_hook.dart';
import '../login_controller.dart';
import '../login_view_state.dart';
import '../widgets/sign_up_flow.dart';


class LoginViewDesktop extends HookConsumerWidget {
  const LoginViewDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneC = useTextEditingController(text: '09');
    final loginController = ref.watch(loginControllerProvider);
    final step = ref.watch(signupStepProvider);
    final start = useState(60);
    final phone = useState(phoneC.text);
    useEffect(() {
      loginController.checkUser();
    }, []);
    useEffect(() {
      phone.value = phoneC.text;
    }, [useListenable(phoneC).text]);
    useEffect(() {
      start.value = 60;
    }, [step]);
    final resendCode = useCallback(() async {
      start.value = 60;
      await loginController.sendSMS(phoneC.text);
    }, []);
    final resendOtpLoginCode = useCallback(() async {
      start.value = 60;
      await loginController.otpLogin(phoneC.text);
    }, []);
    final timer = useInterval(() {
      if (start.value < 1) return;

      start.value = start.value - 1;
    }, Duration(seconds: 1));

    return SafeArea(
      child: Scaffold(
        floatingActionButton: Padding(padding: const EdgeInsets.all(8.0), child: AppLangWidget()),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: IndexedStack(
          index: step,
          children: [
            InitialCheckPhoneWidget(phoneC: phoneC),
            SendCodeWidget(onSendCode: resendCode, phone: phone.value),
            ConfirmActiveCodeWidget(
              onBack: () => ref.read(signupStepProvider.notifier).update((s) => 0),
              onConfirmCode: (code) => loginController.confirmRegister(phoneC.text, code),
              onChangePhone: () => ref.read(signupStepProvider.notifier).update((s) => s - 1),
              timerValue: start.value,
              onResendCode: resendCode,
            ),
            CompleteProfileWidget(phone: phone.value),
            LoginWithPasswordWidget(phoneC: phoneC),
            LoginWithOtpWidget(
              onBack: () => ref.read(signupStepProvider.notifier).update((s) => 4),
              onConfirmCode: (code) => loginController.confirmOtpLogin(phoneC.text, code),
              onChangePhone: () {},
              timerValue: start.value,
              onResendCode: resendOtpLoginCode,
            ),
          ],
        ),
      ),
    );
    return SignupViewPhone(myLoginController: loginController);
  }
}
