import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../providers/user_provider.dart';
import 'custom_progress_indicator.dart';

class ConfirmUserDeleteDialog extends StatefulWidget {
  const ConfirmUserDeleteDialog({
    super.key,
    required this.user,
  });

  final Users user;

  @override
  State<ConfirmUserDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmUserDeleteDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => AlertDialog(
        title: const Text("Delete user?"),
        content: Text(
          "Before proceeding, would you like to confirm the deletion of the user profile for ${widget.user.fullName}? This action is irreversible and will permanently remove all associated data.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          isLoading == true
              ? const CustomProgressIndicator()
              : TextButton(
                  onPressed: () {
                    deleteUser(userProvider);
                  },
                  child: const Text("Confirm"),
                ),
        ],
      ),
    );
  }

  void deleteUser(UserProvider userProvider) async {
    setState(() {
      isLoading = true;
    });
    await userProvider.signInUser(widget.user);
    await userProvider.deleteUser(widget.user);
    await userProvider.signInUser(userProvider.user).then(
          (value) => Navigator.pop(context),
        );
    setState(() {
      isLoading = false;
    });
  }
}
