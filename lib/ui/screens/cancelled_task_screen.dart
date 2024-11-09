import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/ui/controllers/cancelled_task_list_controller.dart';
import 'package:task_manager_app_using_getx/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app_using_getx/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app_using_getx/ui/widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  final CancelledTaskListController _cancelledTaskListController = Get.find<CancelledTaskListController>();

  @override
  void initState() {
    _getCancelledTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CancelledTaskListController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.inProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: RefreshIndicator(
            onRefresh: () async {
              _getCancelledTaskList();
            },
            child: ListView.separated(
              itemCount: controller.cancelledTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: controller.cancelledTaskList[index],
                  onRefreshList: _getCancelledTaskList,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
          ),
        );
      }
    );
  }

  Future<void> _getCancelledTaskList() async {
    final bool result = await _cancelledTaskListController.getCancelledTaskList();

    if (result == false) {
      showSnackBarMessage(context, _cancelledTaskListController.errorMessage!, true);
    }
  }
}