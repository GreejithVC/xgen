import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xgen/constants/enums.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          if (userController.pageState == PageState.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (userController.userModel == null) {
            return Center(child: Text("No profile data found"));
          }

          return Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 100, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    "Name: ${userController.userModel!.name}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email: ${userController.userModel!.email}",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
