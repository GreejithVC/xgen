import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../repo/shared_preference_repository.dart';
import '../ui/pages/profile_screen.dart';

class UserController extends ChangeNotifier {
  UserModel? userModel;
  PageState _pageState = PageState.loading;

  PageState get pageState => _pageState;

  set pageState(PageState state) {
    _pageState = state;
    notifyListeners();
  }
  initController() async {
    fetchUserDetails();
  }
  Future<void> fetchUserDetails() async {
    _pageState = PageState.loading;
    var uid = await SharedPreferenceRepository.getToken();
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        userModel = UserModel.fromMap(data, uid);
        debugPrint('Fetched user details: ${userModel?.name}');
        pageState = PageState.success;
      } else {
        debugPrint('User not found');
        userModel = null;
        pageState = PageState.error;
      }
    } catch (error) {
      debugPrint('Error fetching user details: $error');
      userModel = null;
      pageState = PageState.error;
    }
  }
  Future<void> loadUserProfile() async {
    initController();
    Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ));
  }
}
