import 'package:flutter/material.dart';
import 'package:pawfection/login_view.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/voluteer_view.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    builder: (context) => const ManagerView(tab: 1),
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
                    builder: (context) => const VolunteerView(
                      tab: 0,
                    ),
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
        ]);
  }
}
