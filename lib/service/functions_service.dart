import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import '../models/task.dart';
import 'dart:convert';

import '../models/user.dart';

TaskService taskService = TaskService();
UserService userService = UserService();

class FunctionService {

  // In the future the autoAssignment may require some input to auto assign based on what
  Future<Map<String, dynamic>> autoAssign() async {
    HttpsCallable callable =
    FirebaseFunctions.instance.httpsCallable('autoAssign');
    final resp = await callable.call(<String, dynamic>{
      'text': 'A message sent from a client device',
    });
    // Cloud Function response is in Map format.
    // We need to parse it correctly.
    Map<String, dynamic> response = Map<String, dynamic>.from(resp.data);

    List<dynamic> tasksJson = response["tasks"];
    List<dynamic> volunteerJson = response["volunteers"];
    List<Task> tasks = [];
    List<User> volunteers = [];

    for (var taskData in tasksJson) {
      Map<String, dynamic> taskDataMap = jsonDecode(jsonEncode(taskData));
      Task task = taskService.taskFromJsonCloudFunction(taskDataMap);
      tasks.add(task);
    }

    for (var userData in volunteerJson) {
      Map<String, dynamic> userDataMap = jsonDecode(jsonEncode(userData));
      User user = userService.userFromJson(userDataMap);
      volunteers.add(user);
    }

    return {'tasks': tasks, 'volunteers': volunteers};
  }
}
