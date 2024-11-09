import 'package:get/get.dart';
import 'package:task_manager_app_using_getx/data/models/network_response.dart';
import 'package:task_manager_app_using_getx/data/models/task_list_model.dart';
import 'package:task_manager_app_using_getx/data/models/task_model.dart';
import 'package:task_manager_app_using_getx/data/services/network_caller.dart';
import 'package:task_manager_app_using_getx/data/utils/urls.dart';

class CompletedTaskListController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  List<TaskModel> _completedTaskList = [];

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.completedList);

    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _completedTaskList = taskListModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}
