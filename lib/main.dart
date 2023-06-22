import 'package:flutter/material.dart';
import 'package:pawfection/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawfection/login_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: 'Pawfection',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: const Color(0xff3F1845),

      // appBar: AppBar(
      //   title: const Text('First Screen'),
      // ),

      body: LoginView(),
    );
  }
}
