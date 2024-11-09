import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/ui/controllers/auth_controller.dart';
import 'package:task_manager_app_using_getx/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_using_getx/ui/utils/assets_path.dart';
import 'package:task_manager_app_using_getx/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _moveToNextScreen();
    super.initState();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    await AuthController.getAccessToken();
    if (AuthController.isLoggedIn()) {
      await AuthController.getUserData();
      Get.offNamed(MainBottomNavBarScreen.name);
    }else{
      Get.offNamed(SignInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsPath.logoSvg,
                width: 140,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
