import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/users.dart';

class UserProvider with ChangeNotifier {
  FirebaseAuth authInstance = FirebaseAuth.instance;
  FirebaseFirestore cloudInstance = FirebaseFirestore.instance;

  Users _user = const Users(
    id: "null",
    email: "null",
    fullName: "null",
    password: "null",
  );

  Users get user {
    return _user;
  }

  Future<dynamic> createUser(Users user) async {
    try {
      await authInstance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((value) async {
        cloudInstance.collection("users").doc(value.user?.uid).set(
              user.toJson(value.user!.uid),
            );
      });
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        print("The email address is already in use by another account.");
        return "The email address is already in use by another account.";
      } else {
        print(e);
        return e.message;
      }
    } catch (e) {
      notifyListeners();
      print("User create error: $e");
      return Future.error(e);
    }
  }

  Future<dynamic> signInUser(Users user) async {
    try {
      await authInstance.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email/username.');
        return 'No user found for that email/username.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
      } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        print("Invalid login credentials");
        return 'Invalid login credentials. Please check credetials and try again';
      } else {
        print(e);
        return e.message;
      }
    } catch (e) {
      notifyListeners();
      print("User sign in error: $e");
      return Future.error(e);
    }
  }

  Future<dynamic> editUserCred(Users user) async {
    try {
      await cloudInstance
          .collection("users")
          .doc(user.id)
          .update(
            user.toJson(user.id),
          )
          .then((value) async {
        await authInstance.currentUser?.updateEmail(user.email);
        await authInstance.currentUser?.updatePassword(user.password);
      });

      return true;
    } catch (e) {
      notifyListeners();
      print("Edit user error: $e");
      return Future.error(e);
    }
  }

  Future<dynamic> deleteUser(Users user) async {
    try {
      await authInstance.currentUser?.delete().then((value) async {
        await cloudInstance.collection("users").doc(user.id).delete();
      });

      return true;
    } catch (e) {
      notifyListeners();
      print("Delete user error: $e");
      return Future.error(e);
    }
  }

  Future<dynamic> getUserDetails() async {
    String? uid = authInstance.currentUser?.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await cloudInstance.collection("users").doc(uid).get();

      Map<String, dynamic>? data = snapshot.data();

      _user = Users.fromJson(data ?? {});

      notifyListeners();

      return true;
    } catch (e) {
      notifyListeners();
      print("User details error: $e");
      return Future.error(e);
    }
  }

  Stream<QuerySnapshot> getUsers() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
          cloudInstance.collection("users").snapshots();

      return querySnapshot;
    } catch (e) {
      notifyListeners();
      print("Get users error: $e");
      return Stream.error(e);
    }
  }

  void clearUser() {
    _user = const Users(
      id: "null",
      email: "null",
      fullName: "null",
      password: "null",
    );

    notifyListeners();
  }

  bool checkIsAdmin() {
    return _user.id == "Osp5yQdqIqbgIStRHBRazfhR2ts2";
  }
}
