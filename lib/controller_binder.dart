import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/ui/controllers/sign_in_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
  }
}
