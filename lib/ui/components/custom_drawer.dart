import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xgen/controllers/user_controller.dart';

import '../../../constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../main.dart';
import 'options_tile.dart';

class CustomDrawer extends StatelessWidget {
   CustomDrawer({super.key});

  final AuthController authController =
  Provider.of<AuthController>(navigatorKey.currentContext!, listen: false);
   final UserController userController =
   Provider.of<UserController>(navigatorKey.currentContext!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(navigatorKey.currentContext!).size.width - 60,
      height: MediaQuery.of(navigatorKey.currentContext!).size.height - 200,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      margin: EdgeInsets.zero,
      child: _menuOptions(),
    );
  }

  Widget _menuOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          OptionsTile(title: "Profile", image: Icons.person,onTap:  userController.loadUserProfile),
          const SizedBox(height: 20),
          OptionsTile(title: "Logout", image: Icons.logout,onTap:  authController.logoutAlertBox),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
