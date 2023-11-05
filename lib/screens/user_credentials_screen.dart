import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/users.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/search_text_field.dart';
import '../widgets/user_cred_tile.dart';

class UserCredentailsScreen extends StatefulWidget {
  static const routeName = "/UserCredentailsScreen";

  const UserCredentailsScreen({super.key});

  @override
  State<UserCredentailsScreen> createState() => _UserCredentailsScreenState();
}

class _UserCredentailsScreenState extends State<UserCredentailsScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text("User credentials"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/CreateUserScreen", arguments: {
              "type": "Create",
              "user": const Users(
                id: "",
                email: "",
                fullName: "",
                password: "",
              ),
            }),
            icon: Image.asset(
              "assets/icons/plus.png",
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchTextField(
            searchQuery: getSearchQuery,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: userProvider.getUsers(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Something went wrong. Please contact the developer or admin for help',
                    style: TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                        fontSize: 10.sp),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [CustomProgressIndicator()]);
                }

                return Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: snapshot.data!.docs
                        .where((element) => element["fullName"]
                            .toString()
                            .toLowerCase()
                            .contains(
                              searchQuery.toLowerCase(),
                            ))
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      Users user = Users.fromJson(data);

                      return UserCredTile(user: user);
                    }).toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }

  void getSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }
}
