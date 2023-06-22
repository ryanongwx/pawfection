import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/voluteer_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:pawfection/models/user.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  Duration get loginTime => const Duration(milliseconds: 2250);
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  final userRepository = UserRepository();
  final userService = UserService();

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        debugPrint('gone to firebase');
        final credential = await _auth.signInWithEmailAndPassword(
            email: data.name, password: data.password);
      } on FirebaseAuth.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        } else {
          return e.code;
        }
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    // Check for whether email has been registered
    return Future.delayed(loginTime).then((_) async {
      try {
        final credential = await FirebaseAuth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: data.name!,
              password: data.password!,
            )
            .then((Null) => {
                  FirebaseAuth.FirebaseAuth.instance
                      .authStateChanges()
                      .listen((FirebaseAuth.User? user) async {
                    if (user != null) {
                      userService.addUser(User(user.email!,
                          username: user.email!,
                          bio: '',
                          referenceId: user.uid,
                          role: 'Volunteer',
                          availabledates: [],
                          preferences: [],
                          experiences: [],
                          profilepicture:
                              'https://firebasestorage.googleapis.com/v0/b/pawfection-c14ed.appspot.com/o/profilepictures%2FFlFhhBapCZOzattk8mT1CMNxou22?alt=media&token=530bd4b2-95b6-45dc-88f0-9abf64d2a916',
                          contactnumber: ''));
                    }
                  }),
                });
      } on FirebaseAuth.FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
      } catch (e) {
        print(e);
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) async {
      await FirebaseAuth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: name);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FlutterLogin(
          logo: const AssetImage('assets/images/logo.png'),
          onLogin: _authUser,
          onSignup: _signupUser,
          onRecoverPassword: _recoverPassword,
          messages: LoginMessages(
              recoverPasswordIntro: 'Enter your recovery email here',
              recoverPasswordDescription:
                  'An email will be sent to your email addess for password reset.'),
          onSubmitAnimationCompleted: () async {
            FirebaseAuth.User currentUser = _auth.currentUser!;
            User? user = await userService.findUserByUUID(currentUser.uid);
            if (user != null) {
              if (user.role == 'Manager') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ManagerView(
                    tab: 1,
                  ),
                ));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const VolunteerView(
                    tab: 0,
                  ),
                ));
              }
            } else {
              null;
            }
          },
        ));
  }
}
