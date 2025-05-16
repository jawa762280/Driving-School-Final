import 'package:flutter/material.dart';

class InkwellBottomAppbarHome extends StatelessWidget {
  const InkwellBottomAppbarHome(
      {super.key,
      required this.textIcon,
      required this.icon,
      required this.onTap,
      required this.active});
  final String textIcon;
  final IconData icon;
  final void Function() onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active == true ? Colors.green : Colors.grey),
            Text(textIcon,
                style: TextStyle(
                    color: active == true ? Colors.green : Colors.grey,
                    fontSize: 10))
          ],
        ));
  }
}
