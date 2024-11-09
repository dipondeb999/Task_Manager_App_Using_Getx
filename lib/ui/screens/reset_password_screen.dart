import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app_using_getx/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_using_getx/ui/utils/app_colors.dart';
import 'package:task_manager_app_using_getx/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_using_getx/ui/widgets/screen_background.dart';
import 'package:task_manager_app_using_getx/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  final ResetPasswordController _resetPasswordController = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  "Set Password",
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  "Minimum length password 8 character with letter and number combination",
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildResetPasswordForm(),
                const SizedBox(height: 48),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passwordTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter your password';
              }
              if (value!.length <= 6) {
                return 'Enter a password more than 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: "Confirm Password",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter your confirm password';
              }
              if (value != _passwordTEController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<ResetPasswordController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inProgress,
                replacement: const CenteredCircularProgressIndicator(),
                child: ElevatedButton(
                  onPressed: _onTapNextButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpSection() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            text: "Have account? ",
            children: [
              TextSpan(
                style: const TextStyle(
                  color: AppColors.themeColor,
                ),
                text: "Sign In",
                recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton,
              ),
            ]),
      ),
    );
  }

  void _onTapNextButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _recoverResetPassword();
  }

  Future<void> _recoverResetPassword() async {
    final bool result = await _resetPasswordController.recoverResetPassword(
        widget.email,
        _passwordTEController.text,
        widget.otp,
    );

    if (result) {
      showSnackBarMessage(context, 'Password set successfully!');
      Get.offNamedUntil(SignInScreen.name, (_) => false);
    } else {
      showSnackBarMessage(context, _resetPasswordController.errorMessage!, true);
    }
  }

  void _onTapSignUpButton() {
    Get.offNamedUntil(SignInScreen.name, (_) => false);
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
