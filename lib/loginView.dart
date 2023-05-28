import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:pawfection/volunteerscreens/v_dashboard_screen.dart';
import 'package:pawfection/voluteerView.dart';
import 'package:firebase_auth/firebase_auth.dart';

const users = const {
  'soo@gmail.com': 'soo',
  'ryan@gmail.com': 'ryan',
};

class LoginView extends StatelessWidget {
  LoginView({super.key});
  Duration get loginTime => Duration(milliseconds: 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        debugPrint('gone to firebase');
        final credential = await _auth.signInWithEmailAndPassword(
            email: data.name, password: data.password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        } else {
          return e.code;
        }
      }
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name!,
          password: data.password!,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) async {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
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
          messages: LoginMessages(
              recoverPasswordIntro: 'Enter your recovery email here',
              recoverPasswordDescription:
                  'An email will be sent to your email addess for password reset.'),
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => VolunteerView(
                tab: 0,
              ),
            ));
          },
        ));
  }
}
