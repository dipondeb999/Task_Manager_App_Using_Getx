import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app_using_getx/ui/controllers/auth_controller.dart';
import 'package:task_manager_app_using_getx/ui/controllers/profile_controller.dart';
import 'package:task_manager_app_using_getx/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_using_getx/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_using_getx/ui/widgets/task_manager_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final ProfileController _profileController = Get.find<ProfileController>();

  XFile? _selectedImage;

  void _setUserData() {
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _phoneTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  void initState() {
    _setUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskManagerAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                "Update Profile",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              _buildPhotoPicker(),
              const SizedBox(height: 24),
              _buildTextFormFields(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                  "Photo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(_getSelectedPhotoTitle()),
          ],
        ),
      ),
    );
  }

  String _getSelectedPhotoTitle() {
    if (_selectedImage != null) {
      return _selectedImage!.name;
    }
    return 'Selected Photo';
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }

  Widget _buildTextFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: false,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _firstNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'First name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _lastNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'Last name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneTEController,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'Phone',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          const SizedBox(height: 24),
          GetBuilder<ProfileController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inProgress,
                replacement: const CenteredCircularProgressIndicator(),
                child: ElevatedButton(
                  onPressed: _onTapUpdateButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updatedProfile();
    }
  }

  Future<void> _updatedProfile() async {
    final bool result = await _profileController.profileUpdate(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _phoneTEController.text.trim(),
        _passwordTEController.text,
    );

    if (result) {
        showSnackBarMessage(context, 'Profile has been updated!');
    } else {
        showSnackBarMessage(context, _profileController.errorMessage!, true);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
