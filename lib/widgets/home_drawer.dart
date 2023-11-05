import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/users.dart';
import '../providers/user_provider.dart';
import 'drawer_tile.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.w,
        top: 8.h,
        bottom: 2.h,
      ),
      child: Drawer(
        elevation: 10,
        width: 60.w,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          Users user = userProvider.user;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerTile(
                label: user.fullName,
                icon: Icons.person_rounded,
                function: () => null,
              ),
              DrawerTile(
                label: user.email,
                icon: Icons.email_rounded,
                function: () => null,
              ),
              Visibility(
                visible: userProvider.checkIsAdmin(),
                child: StreamBuilder<QuerySnapshot>(
                    stream: userProvider.getUsers(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      int totalUsers = snapshot.data?.size ?? 0;
                      if (snapshot.hasError) {
                        return userManagementTile(totalUsers, context);
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return userManagementTile(totalUsers, context);
                      }

                      return userManagementTile(totalUsers, context);
                    }),
              ),
              DrawerTile(
                label: "Sign out",
                icon: Icons.logout_rounded,
                color: Colors.red,
                function: () => FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/LoginScreen", (route) => false);
                  userProvider.clearUser();
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  DrawerTile userManagementTile(int totalUsers, BuildContext context) {
    return DrawerTile(
      label: "User management ($totalUsers)",
      icon: Icons.people_rounded,
      function: () => Navigator.pushNamed(
        context,
        "/UserCredentailsScreen",
      ),
    );
  }
}
