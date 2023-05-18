import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';

class VProfileScreen extends StatelessWidget {
  const VProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Sample')),
        body: const FormExample(),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  String title = "Spheria";
  String author = "Cody Leet";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CardSettings(
        children: <CardSettingsSection>[
          CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Favorite Book',
          ),
          children: <CardSettingsWidget>[
            CardSettingsText(
              label: 'Title',
              initialValue: title,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              onSaved: (value) => title = value!,
            ),
            CardSettingsDateTimePicker(

            )
          ],
          ),
        ],
      ),
    );
  }
}
