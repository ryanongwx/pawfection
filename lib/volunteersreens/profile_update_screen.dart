import 'dart:core';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';

class VProfileUpdateScreen extends StatefulWidget {
  const VProfileUpdateScreen({super.key});

  @override
  State<VProfileUpdateScreen> createState() => _VProfileUpdateScreenState();
}

class _VProfileUpdateScreenState extends State<VProfileUpdateScreen> {
  String name = "Test";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tasks = ["walking", "washing", "playing"];
  List<String>? tasksSelected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Update Profile")),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CardSettings(
                children: <CardSettingsSection>[
                  CardSettingsSection(
                    children: <CardSettingsWidget>[
                      CardSettingsText(
                        label: 'Name',
                        initialValue: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required.';
                          }
                        },
                        onSaved: (value) => name = value!,
                      ),
                      CardSettingsText(
                        label: 'Experience',
                        initialValue: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required.';
                          }
                        },
                        onSaved: (value) => name = value!,
                      ),
                      CardSettingsCheckboxPicker(
                          key: _formKey,
                          label: 'Task Preference',
                          initialItems: tasks,
                          items: tasks,
                          onSaved: (value) => tasksSelected = value)
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
