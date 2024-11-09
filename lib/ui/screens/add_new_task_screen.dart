import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_app_using_getx/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_using_getx/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_using_getx/ui/widgets/task_manager_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  bool _shouldRefreshPreviousPage = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final AddNewTaskController _addNewTaskController = Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshPreviousPage);
      },
      child: Scaffold(
        appBar: const TaskManagerAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 42),
                Text(
                  "Add New Task",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                _buildTextFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTextFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter a value';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter a value';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<AddNewTaskController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inProgress,
                replacement: const CenteredCircularProgressIndicator(),
                child: ElevatedButton(
                  onPressed: _onTapSubmittedButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  void _onTapSubmittedButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _shouldRefreshPreviousPage = true;

    final bool result = await _addNewTaskController.addNewTask(
        _titleTEController.text.trim(),
        _descriptionTEController.text.trim(),
    );

    if (result) {
      _clearTextFields();
      showSnackBarMessage(context, 'New task added!');
    }else{
      showSnackBarMessage(context, _addNewTaskController.errorMessage!, true);
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
