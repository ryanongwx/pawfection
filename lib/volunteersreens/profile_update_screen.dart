import 'dart:core';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';

class VProfileUpdateScreen extends StatelessWidget {
  const VProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FormExample()
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  String name = "Test";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tasks = [
    "walking", "washing", "playing"
  ];
  List<String>? tasksSelected = [];

  @override
  Widget build(BuildContext context) {
    return Form(
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
                      if (value == null || value.isEmpty) return 'Title is required.';
                    },
                    onSaved: (value) => name = value!,
                  ),
                  CardSettingsText(
                    label: 'Experience',
                    initialValue: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Title is required.';
                    },
                    onSaved: (value) => name = value!,
                  ),
                  CardSettingsCheckboxPicker(
                      key: _formKey,
                      label: 'Hobbies',
                      initialItems: tasks,
                      items: tasks,
                      onSaved: (value) => tasksSelected = value
                  )
                ],
              ),
            ],
          ),
          CardSettingsHeader(
              label: "Available Dates"
          )
        ],
      ),
    );
  }
}
