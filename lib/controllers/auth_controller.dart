import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/enums.dart';
import '../main.dart';
import '../repo/shared_preference_repository.dart';
import '../ui/pages/notes_screen.dart';
import '../ui/pages/login_screen.dart';
import '../ui/pages/sign_up_screen.dart';
import '../utils/widget_utils.dart';

class AuthController with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String? error;

  PageState _pageState = PageState.loading;

  set pageState(final PageState value) {
    _pageState = value;
    notifyListeners();
  }

  PageState get pageState => _pageState;

  intiController() {
    _pageState = PageState.initial;
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }

  Future<void> createUserWithEmailAndPassword() async {
    pageState = PageState.loading;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (credential.user?.uid != null) {
        loaNotesScreen(uid: credential.user!.uid, isFromSignUp: true);
      }
      pageState = PageState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        pageState = PageState.error;
        WidgetUtils.showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        pageState = PageState.error;
        WidgetUtils.showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
      WidgetUtils.showSnackBar(e.toString());
      pageState = PageState.error;
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    pageState = PageState.loading;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (credential.user?.uid != null) {
        loaNotesScreen(uid: credential.user!.uid);
      }
      pageState = PageState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        pageState = PageState.error;
        WidgetUtils.showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        WidgetUtils.showSnackBar('Wrong password provided for that user.');
        pageState = PageState.error;
      } else if (e.code == 'invalid-credential') {
        debugPrint('invalid-credential.');
        WidgetUtils.showSnackBar('invalid-credential.');
        pageState = PageState.error;
      }
    } catch (e) {
      debugPrint(e.toString());
      WidgetUtils.showSnackBar(e.toString());
      pageState = PageState.error;
    }
  }

  logoutAlertBox() {
    WidgetUtils.showLogoutPopUp(navigatorKey.currentContext!,
        sBtnFunction: () => signOut());
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await SharedPreferenceRepository.setToken("");
    loadLoginScreen();
  }

  loaNotesScreen({required String uid, bool isFromSignUp = false}) async {
    if (isFromSignUp) {
      await fireStore.collection('users').doc(uid).set({
        'name': nameController.text,
        'email': emailController.text,
      }, SetOptions(merge: true));
    }
    await SharedPreferenceRepository.setToken(uid);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (final context) => const NotesScreen()),
    );
  }

  void loadLoginScreen() {
    intiController();
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  void loadSignUpScreen() {
    intiController();
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ),
        (Route<dynamic> route) => false);
  }
}
