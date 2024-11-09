import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/cancelled_task_list_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/completed_task_list_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/forgot_password_email_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/forgot_password_otp_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/new_task_list_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/profile_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/progress_task_list_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/sign_in_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/sign_up_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(CompletedTaskListController());
    Get.put(CancelledTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(ForgotPasswordEmailController());
    Get.put(ForgotPasswordOtpController());
    Get.put(ResetPasswordController());
    Get.put(AddNewTaskController());
    Get.put(SignUpController());
    Get.put(ProfileController());
  }
}
