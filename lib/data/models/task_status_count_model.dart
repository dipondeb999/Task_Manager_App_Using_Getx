import 'package:task_manager_app_using_getx/data/models/task_status_model.dart';

class TaskStatusCountModel {
  String? status;
  List<TaskStatusModel>? taskStatusCountList;

  TaskStatusCountModel({this.status, this.taskStatusCountList});

  TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCountList = <TaskStatusModel>[];
      json['data'].forEach((v) {
        taskStatusCountList!.add(new TaskStatusModel.fromJson(v));
      });
    }
  }
}
