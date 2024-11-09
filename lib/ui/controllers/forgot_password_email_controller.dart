import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/data/models/network_response.dart';
import 'package:task_manager_app_using_getx/data/services/network_caller.dart';
import 'package:task_manager_app_using_getx/data/utils/urls.dart';

class ForgotPasswordEmailController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> recoverVerifyEmail(String email) async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.verifyEmail(email));

    if (response.isSuccess) {
      isSuccess = true;
    }else{
      _errorMessage = errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}