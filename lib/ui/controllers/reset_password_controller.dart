import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/data/models/network_response.dart';
import 'package:task_manager_app_using_getx/data/services/network_caller.dart';
import 'package:task_manager_app_using_getx/data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> recoverResetPassword(String email, String password, String otp) async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPassword,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}