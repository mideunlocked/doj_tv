import 'package:flutter/material.dart';

class LiveScreenAppBarIcon extends StatelessWidget {
  const LiveScreenAppBarIcon({
    super.key,
    this.icon,
    this.iconUrl = "",
    required this.function,
  });

  final IconData? icon;
  final String iconUrl;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => function(),
        icon: iconUrl.isNotEmpty
            ? Image.asset(iconUrl)
            : Icon(
                icon,
              ),
      ),
    );
  }
}
