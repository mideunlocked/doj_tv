import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.node,
    this.inputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    required this.label,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction inputAction;
  final FocusNode node;
  final bool isPassword;
  final String label;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = true;

  void toggleObscure() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white60),
      borderRadius: BorderRadius.circular(15),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.node,
        textInputAction: widget.inputAction,
        keyboardType: widget.textInputType,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: widget.isPassword ? isVisible : false,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: "Enter your ${widget.label.toLowerCase()}",
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
          hintStyle: const TextStyle(color: Colors.white24),
          suffixIcon: Visibility(
            visible: widget.isPassword,
            child: IconButton(
              onPressed: toggleObscure,
              icon: Icon(
                isVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: Colors.white38,
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "${widget.label} is required";
          }
          if (widget.label.contains("Email") && !value.contains(".com")) {
            return "Enter a valid ${widget.label.toLowerCase()}";
          }
          return null;
        },
      ),
    );
  }
}
