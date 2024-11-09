import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/controller_binder.dart';
import 'package:task_manager_app_using_getx/ui/controllers/sign_in_controller.dart';
import 'package:task_manager_app_using_getx/ui/screens/forgot_password_email_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/sign_up_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/splash_screen.dart';
import 'package:task_manager_app_using_getx/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),
      initialBinding: ControllerBinder(),
      initialRoute: '/',
      routes: {
        SplashScreen.name: (context) => const SplashScreen(),
        MainBottomNavBarScreen.name: (context) => const MainBottomNavBarScreen(),
        ForgotPasswordEmailScreen.name: (context) => const ForgotPasswordEmailScreen(),
        SignUpScreen.name: (context) => const SignUpScreen(),
        SignInScreen.name: (context) => const SignInScreen(),
      },
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
    );
  }

  InputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.themeColor,
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
