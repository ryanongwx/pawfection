import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import '../models/task.dart';
import 'dart:convert';

TaskService taskService = TaskService(FirebaseFirestore.instance);
UserService userService = UserService(FirebaseFirestore.instance);

class FunctionService {
  // In the future the autoAssignment may require some input to auto assign based on what
  Future<Map<String, dynamic>> autoAssign() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-pawfection-c14ed.cloudfunctions.net/autoAssign'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      Map<String, dynamic> responseMap = jsonDecode(response.body);

      List<dynamic> tasksJson = responseMap["tasks"];
      Map<String, dynamic> tasksVolunteersMapJson =
      Map<String, dynamic>.from(responseMap["volunteers"]);
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
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load autoAssign');
    }
  }
}