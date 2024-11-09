import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app_using_getx/data/models/network_response.dart';
import 'package:task_manager_app_using_getx/data/models/user_model.dart';
import 'package:task_manager_app_using_getx/data/services/network_caller.dart';
import 'package:task_manager_app_using_getx/data/utils/urls.dart';
import 'package:task_manager_app_using_getx/ui/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  XFile? _selectedImage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  XFile? get selectImage => _selectedImage;

  Future<bool> profileUpdate(String email, String firstName, String lastName, String mobile, String password) async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (_selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}