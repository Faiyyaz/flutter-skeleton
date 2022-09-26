import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double? iconSize;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPressed();
      },
      icon: Icon(
        icon,
        color: iconColor ?? _getIconColor(context),
        size: iconSize,
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    if (iconColor != null) {
      return iconColor!;
    } else {
      return Theme.of(context).iconTheme.color!;
    }
  }
}
