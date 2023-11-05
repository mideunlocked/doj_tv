import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../models/users.dart';
import 'confirm_user_delete_dialog.dart';

class UserCredTile extends StatelessWidget {
  const UserCredTile({
    super.key,
    required this.user,
  });

  final Users user;

  @override
  Widget build(BuildContext context) {
    var subTitleStyle = const TextStyle(
      color: Colors.white54,
    );
    var primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white30,
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                user.email,
                style: subTitleStyle,
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                user.password,
                style: subTitleStyle,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/CreateUserScreen", arguments: {
              "type": "Update",
              "user": user,
            }),
            icon: Icon(
              Icons.edit_rounded,
              color: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () => showConfirmDeleteDialog(context),
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmUserDeleteDialog(
        user: user,
      ),
    );
  }
}
