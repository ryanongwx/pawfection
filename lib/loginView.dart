import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:pawfection/volunteersreens/v_dashboard_screen.dart';
import 'package:pawfection/voluteerView.dart';

const users = const {
  'soo@gmail.com': 'soo',
  'ryan@gmail.com': 'ryan',
};

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User does not exist';
      }
      if (users[data.name] != data.password) {
        return 'Passwords do not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User does not exist';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FlutterLogin(
          logo: AssetImage('assets/images/logo.png'),
          onLogin: _authUser,
          onSignup: _signupUser,
          onRecoverPassword: _recoverPassword,
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => VDashboardScreen(),
            ));
          },
        ));
  }
}
