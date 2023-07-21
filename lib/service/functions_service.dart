import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import '../models/task.dart';
import 'dart:convert';

TaskService taskService = TaskService(FirebaseFirestore.instance);
UserService userService = UserService(FirebaseFirestore.instance);

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
    Map<String, dynamic> tasksVolunteersMapJson =
        Map<String, dynamic>.from(response["volunteers"]);
    List<Task> tasks = [];

    for (var taskData in tasksJson) {
      Map<String, dynamic> taskDataMap = jsonDecode(jsonEncode(taskData));
      Task task = taskService.taskFromJsonCloudFunction(taskDataMap);
      tasks.add(task);
    }

    // Convert the map values from List<dynamic> to List<String>
    Map<String, List<String>> tasksVolunteersMap =
        tasksVolunteersMapJson.map((key, value) {
      List<String> volunteersList =
          List<String>.from(value.map((item) => item.toString()));
      return MapEntry(key, volunteersList);
    });

    return {'tasks': tasks, 'volunteers': tasksVolunteersMap};
  }
}
