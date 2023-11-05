import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../helpers/snack_bar_helper.dart';
import '../models/users.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CreateUserScreen extends StatefulWidget {
  static const routeName = "/CreateUserScreen";
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  bool isLoading = false;
  bool checkType = false;

  Map<String, dynamic> args = {};

  Users user = const Users(
    id: "id",
    fullName: "",
    email: "",
    password: "",
  );

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final fullNameNode = FocusNode();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    fullNameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    checkType = args["type"] == "Create";
    user = args["user"] as Users;

    fullNameController = TextEditingController(text: user.fullName);
    emailController = TextEditingController(text: user.email);
    passwordController = TextEditingController(text: user.password);
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: Text(checkType ? "Create user" : "Update user"),
          toolbarHeight: 50,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: fullNameController,
                          node: fullNameNode,
                          label: "Full name",
                          textInputType: TextInputType.name,
                        ),
                        CustomTextField(
                          controller: emailController,
                          node: emailNode,
                          label: "Email address",
                          textInputType: TextInputType.emailAddress,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          node: passwordNode,
                          label: "Password",
                          isPassword: true,
                          inputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomButton(
                labelText: checkType ? "Create user" : "Update user",
                function: checkType ? createNewUser : updateUser,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createNewUser() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    if (isValid == false) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });

      var response = await userProvider.createUser(
        Users(
          id: "id",
          email: emailController.text.trim(),
          fullName: fullNameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      if (response != true) {
        setState(() {
          isLoading = false;
        });

        CustomSnackBar.showCustomSnackBar(_scaffoldKey, response);
      } else {
        setState(() {
          isLoading = false;
        });

        await userProvider.signInUser(
          Users(
            id: userProvider.user.id,
            email: userProvider.user.email,
            fullName: userProvider.user.fullName,
            password: userProvider.user.password,
          ),
        );
        emailController.clear();
        fullNameController.clear();
        passwordController.clear();

        if (mounted) {
          CustomSnackBar.showCustomSnackBar(
            _scaffoldKey,
            "Created user successfully",
            color: Colors.green,
          );
        }
      }
    }
  }

  void updateUser() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    if (isValid == false) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });

      await userProvider.signInUser(user);
      var response = await userProvider.editUserCred(
        Users(
          id: user.id,
          email: emailController.text.trim(),
          fullName: fullNameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
      await userProvider.signInUser(userProvider.user);

      if (response != true) {
        setState(() {
          isLoading = false;
        });

        CustomSnackBar.showCustomSnackBar(_scaffoldKey, response);
      } else {
        setState(() {
          isLoading = false;
        });

        if (mounted) {
          CustomSnackBar.showCustomSnackBar(
            _scaffoldKey,
            "Updated user successfully",
            color: Colors.green,
          );
        }
      }
    }
  }
}
