import 'package:doj_tv/helpers/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/users.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailNode = FocusNode();
  final passwordNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();

    emailNode.dispose();
    passwordNode.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/images/dojtv.png"),
                    CustomTextField(
                      controller: emailController,
                      node: emailNode,
                      textInputType: TextInputType.emailAddress,
                      label: "Email address",
                    ),
                    CustomTextField(
                      controller: passwordController,
                      node: passwordNode,
                      isPassword: true,
                      label: "Password",
                      inputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 8.h),
                    CustomButton(
                      isLoading: isLoading,
                      labelText: "Sign in",
                      function: signIn,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    if (isValid == false) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });

      final response = await userProvider.signInUser(
        Users(
          id: "id",
          email: emailController.text.trim(),
          fullName: "",
          password: passwordController.text.trim(),
        ),
      );

      if (response != true) {
        setState(() {
          isLoading = false;
        });

        CustomSnackBar.showCustomSnackBar(_scaffoldKey, response);
        return;
      }

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/",
          (route) => false,
        );
      }
    }
  }
}
