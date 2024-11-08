import 'package:flutter/material.dart';
import 'package:task_manager_app_using_getx/ui/controllers/auth_controller.dart';
import 'package:task_manager_app_using_getx/ui/screens/profile_screen.dart';
import 'package:task_manager_app_using_getx/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app_using_getx/ui/utils/app_colors.dart';

class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isProfileScreenOpen;
  const TaskManagerAppBar({super.key, this.isProfileScreenOpen = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                  (predicate) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
