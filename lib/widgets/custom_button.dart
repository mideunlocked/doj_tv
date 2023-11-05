import 'package:flutter/material.dart';

import 'custom_progress_indicator.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.isLoading = false,
    required this.labelText,
    required this.function,
  });

  final bool isLoading;
  final String labelText;
  final Function function;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton.extended(
      onPressed: () => function(),
      label: isLoading
          ? const CustomProgressIndicator()
          : Text(
              labelText,
              style: const TextStyle(
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
      backgroundColor: primaryColor,
    );
  }
}
