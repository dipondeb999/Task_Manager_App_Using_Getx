import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/data/models/network_response.dart';
import 'package:task_manager_app_using_getx/data/models/task_status_count_model.dart';
import 'package:task_manager_app_using_getx/data/models/task_status_model.dart';
import 'package:task_manager_app_using_getx/data/services/network_caller.dart';
import 'package:task_manager_app_using_getx/data/utils/urls.dart';
import 'package:task_manager_app_using_getx/ui/controllers/new_task_list_controller.dart';
import 'package:task_manager_app_using_getx/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app_using_getx/ui/utils/app_colors.dart';
import 'package:task_manager_app_using_getx/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_using_getx/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_using_getx/ui/widgets/task_card.dart';
import 'package:task_manager_app_using_getx/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTaskStatusCountListInProgress = false;

  List<TaskStatusModel> _taskStatusCountList = [];

  final NewTaskListController _newTaskListController = Get.find<NewTaskListController>();

  @override
  void initState() {
    _getNewTaskList();
    _getTaskStatusCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inProgress,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ListView.separated(
                      itemCount: controller.newTaskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskModel: controller.newTaskList[index],
                          onRefreshList: _getNewTaskList,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFloatingActionButton,
        backgroundColor: AppColors.themeColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !_getTaskStatusCountListInProgress,
        replacement: const CenteredCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummaryCardList(),
          ),
        ),
      ),
    );
  }

  List<TaskSummaryCard> _getTaskSummaryCardList() {
    List<TaskSummaryCard> taskSummaryCardList = [];
    for ( TaskStatusModel t in _taskStatusCountList) {
      taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummaryCardList;
  }

  Future<void> _onTapFloatingActionButton() async {
    bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if (shouldRefresh == true) {
      _getNewTaskList();
    }
  }

  Future<void> _getNewTaskList() async {
    final bool result = await _newTaskListController.getNewTaskList();

    if (result == false) {
      showSnackBarMessage(context, _newTaskListController.errorMessage!, true);
    }
  }

  Future<void> _getTaskStatusCount() async {
    _taskStatusCountList.clear();
    _getTaskStatusCountListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskStatusCount);
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getTaskStatusCountListInProgress = false;
    setState(() {});
  }
}
