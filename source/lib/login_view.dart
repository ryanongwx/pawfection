import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/voluteer_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:pawfection/models/user.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;

  final userRepository = UserRepository(FirebaseFirestore.instance);

  final userService = UserService(FirebaseFirestore.instance);

  var accesscode = '';

  bool signup = false;

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        debugPrint('gone to firebase');
        final credential = await _auth.signInWithEmailAndPassword(
            email: data.name, password: data.password);
        setState(() {
          accesscode = credential.user!.uid;
        });
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
        signup = true;
        if (data.additionalSignupData != null) {
          User? user = await userService
              .findUserByUUID(data.additionalSignupData!['accesscode']!);

          if (user == null) {
            return 'Invalid Access Code';
          } else if (user.email == data.name) {
            setState(() {
              accesscode = data.additionalSignupData!['accesscode']!;
            });
            await FirebaseAuth.FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: data.name!,
              password: data.password!,
            );
          }
        }
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

    try {
      final fetchMethodsResult = await FirebaseAuth.FirebaseAuth.instance
          .fetchSignInMethodsForEmail(name);

      if (fetchMethodsResult.isEmpty) {
        return "Invalid email";
      }

      await FirebaseAuth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: name);
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accesscode = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterLogin(
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      additionalSignupFields: [
        UserFormField(
            keyName: 'accesscode',
            displayName: 'Access Code',
            icon: Icon(Icons.lock))
      ],
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
          additionalSignUpFormDescription: 'Enter Access Code',
          signUpSuccess: 'Sign In Successful',
          recoverPasswordIntro: 'Enter your recovery email here',
          recoverPasswordDescription:
              'An email will be sent to your email addess for password reset.'),
      onSubmitAnimationCompleted: () async {
        User? user = await userService.findUserByUUID(accesscode);
        FirebaseAuth.User currentUser = _auth.currentUser!;
        if (user != null) {
          if (signup) {
            // Create new user in User Firestore Database and delete current user

            userService.updateUserUid(user, currentUser.uid);
            userService.addUserWithId(User(user.email,
                referenceId: currentUser.uid,
                username: user.username,
                role: user.role,
                availabledates: user.availabledates,
                preferences: user.preferences,
                experiences: user.experiences,
                profilepicture: user.profilepicture,
                contactnumber: user.contactnumber,
                bio: user.bio,
                taskcount: 0));
            userService.deleteUser(user);
          }
          if (user.role == 'manager') {
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
