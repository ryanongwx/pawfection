import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/task_repository.dart';

class TaskService {
  // _userFromJson turns a map of values from Firestore into a User class.
  TaskRepository taskRepository = TaskRepository();

  Task taskFromJson(Map<String, dynamic> json) {
    debugPrint('Deadline raw data: ${json['deadline']}');
    return Task(json['name'] as String,
        referenceId: json['referenceId'] as String,
        assignedto: json['assignedto'] as String?,
        createdby: json['createdby'] as String,
        description: json['description'] as String,
        status: json['status'] as String,
        resources: json['resources'].cast<String?>() as List<String?>,
        contactperson: json['contactperson'] as String,
        contactpersonnumber: json['contactpersonnumber'] as String,
        feedback: json['feedback'] as String?,
        deadline: json['deadline'].cast<Timestamp?>() as List<Timestamp?>,
        requests: json['requests'].cast<String?>() as List<String?>,
        pet: json['pet'] as String?);
  }

  Map<String, dynamic> taskToJson(Task instance) => <String, dynamic>{
        'name': instance.name.toLowerCase(),
        'createdby': instance.createdby,
        'referenceId': instance.referenceId,
        'assignedto': instance.assignedto,
        'description': instance.description,
        'status': instance.status,
        'resources': instance.resources,
        'requests': instance.requests,
        'contactperson': instance.contactperson,
        'contactpersonnumber': instance.contactpersonnumber,
        'feedback': instance.feedback,
        'deadline': instance.deadline,
        'pet': instance.pet,
      };

  Task taskFromJsonCloudFunction(Map<String, dynamic> json) {
    return Task(
      json['name'] as String,
      referenceId: json['referenceId'] as String,
      assignedto: json['assignedto'] as String?,
      createdby: json['createdby'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      resources: (json['resources'] as List<dynamic>).cast<String>(),
      contactperson: json['contactperson'] as String,
      contactpersonnumber: json['contactpersonnumber'] as String,
      feedback: json['feedback'] as String?,
      deadline: (json['deadline'] as List).map((item) {
        Map<String, dynamic> data = item;
        return Timestamp(data['_seconds'], data['_nanoseconds']);
      }).toList().cast<Timestamp>(),
      requests: (json['requests'] as List<dynamic>).cast<String>(),
      pet: json['pet'] as String?,
    );
  }

  Task fromSnapshot(DocumentSnapshot snapshot) {
    final newTask = taskFromJson(snapshot.data() as Map<String, dynamic>);
    newTask.referenceId = snapshot.reference.id;
    return newTask;
  }

  List<Task> snapshotToTaskList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return taskFromJson(data);
      }).toList();
    }
  }

  List<Task> snapshotToTaskListModified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
            as Map<String, dynamic>; // Cast to the correct data type
        return taskFromJson(data);
      }).toList();
    }
  }

  void updateTask(Task task) async {
    debugPrint('Updating task: $task');
    final json = taskToJson(task);
    debugPrint('Serialized JSON: $json');
    taskRepository.updateTaskRepo(json, task.referenceId);
  }

  void deleteTask(Task task) {
    taskRepository.deleteTaskRepo(task.referenceId);
  }

  Future<String> addTask(Task task) async {
    var taskJson = taskToJson(task);
    return await taskRepository.addTaskRepo(taskJson);
  }

  Future<Task?> findTaskByTaskID(String referenceId) async {
    final snapshot = await taskRepository.fetchAllTasks();
    final tasks = snapshotToTaskListModified(snapshot);

    for (Task task in tasks) {
      if (task.referenceId == referenceId) {
        return task;
      }
    }

    return null;
  }

  bool isAvailableWithinDeadline(User user, Task task) {
    return user.availabledates.any((date) {
      DateTime availableDate = date!.toDate();
      DateTime availableDateOnly =
          DateTime(availableDate.year, availableDate.month, availableDate.day);

      DateTime startDeadline = task.deadline[0]!.toDate();
      DateTime startDeadlineOnly =
          DateTime(startDeadline.year, startDeadline.month, startDeadline.day);

      DateTime endDeadline = task.deadline[1]!.toDate();
      DateTime endDeadlineOnly =
          DateTime(endDeadline.year, endDeadline.month, endDeadline.day);

      return (availableDateOnly.difference(startDeadlineOnly).inDays >= 0) &&
          (endDeadlineOnly.difference(availableDateOnly).inDays >= 0);
    });
  }
}
