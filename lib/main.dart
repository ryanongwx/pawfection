import 'package:flutter/material.dart';
import 'package:pawfection/managerview.dart';
import 'package:pawfection/voluteerView.dart';
import 'package:pawfection/loginview.dart';
import 'package:firebase_core/firebase_core.dart';
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

      body: Center(
        child: Column(
            // A container takes one child widget as an argumrent
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),

              // Manager view Button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManagerView(),
                      ),
                    );
                  },
                  child: const Text('Manager View')),

              // Volunteer view Button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VolunteerView(),
                      ),
                    );
                  },
                  child: const Text('Volunteer View')),

              // Volunteer view Button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginView(),
                      ),
                    );
                  },
                  child: const Text('Login View'))
            ]),
      ),
    );
  }
}
