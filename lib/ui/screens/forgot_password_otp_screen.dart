import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app_using_getx/data/models/network_response.dart';
import 'package:task_manager_app_using_getx/data/services/network_caller.dart';
import 'package:task_manager_app_using_getx/data/utils/urls.dart';
import 'package:task_manager_app_using_getx/ui/controllers/forgot_password_otp_controller.dart';
import 'package:task_manager_app_using_getx/ui/screens/reset_password_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_using_getx/ui/utils/app_colors.dart';
import 'package:task_manager_app_using_getx/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_using_getx/ui/widgets/screen_background.dart';
import 'package:task_manager_app_using_getx/ui/widgets/snack_bar_message.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordOTPScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOTPScreen> createState() => _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();

  final ForgotPasswordOtpController _forgotPasswordOtpController = Get.find<ForgotPasswordOtpController>();

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
                  "Pin Verification",
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  "A 6 digits verification OTP has been sent to your email address",
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildPinVerificationSection(),
                const SizedBox(height: 48),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinVerificationSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PinCodeTextField(
            controller: _pinController,
            appContext: context,
            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            validator: (String? value) {
              if (value == null || value.isEmpty || value.length != 6) {
                return 'Enter a 6-digit verification code';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<ForgotPasswordOtpController>(
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
    if(!_formKey.currentState!.validate()) {
      return;
    }
    _recoverVerifyOtp(widget.email, _pinController.text);
  }

  Future<void> _recoverVerifyOtp(String email, String otp) async {
    final bool result = await _forgotPasswordOtpController.recoverVerifyOtp(email, otp);

    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: email,
            otp: otp,
          ),
        ),
      );
    } else {
      showSnackBarMessage(context, _forgotPasswordOtpController.errorMessage!, true);
    }
  }

  void _onTapSignUpButton() {
    Get.offNamedUntil(SignInScreen.name, (_) => false);
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
