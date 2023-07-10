import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/service/task_service.dart';
import '../models/task.dart';

TaskService taskService = TaskService();

class FunctionService {
  // In the future the autoAssignment may require some input to auto assign based on what
  Future<List<Task?>> autoAssign() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('autoAssign');
    final resp = await callable.call(<String, dynamic>{
      'text': 'A message sent from a client device',
    });
    // Cloud Function response is in Map format.
    // We need to parse it correctly.
    Map<String, dynamic> response = Map<String, dynamic>.from(resp.data);

    // Access the openTasks field.
    List<dynamic> openTasks = response["availableTasks"];
    List<Task> tasks = [];

    for (var taskData in openTasks) {
      Map<String, dynamic> taskDataMap =
      Map<String, dynamic>.from(taskData as Map<Object?, Object?>);
      Task task = taskService.taskFromJson(taskDataMap);
      tasks.add(task);
    }

    return tasks;
  }
}
