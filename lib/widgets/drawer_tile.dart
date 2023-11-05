import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.label,
    this.color = Colors.black,
    required this.icon,
    required this.function,
  });

  final Color? color;
  final String label;
  final IconData icon;
  final Function? function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: () => function!(),
    );
  }
}
