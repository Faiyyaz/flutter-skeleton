import 'package:flutter/material.dart';

import '../../utilities/ui_constants.dart';
import '../text/custom_text.dart';

class CustomTextButton extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final TextStyle? textStyle;
  final String fontFamily;
  final FontWeight fontWeight;
  final double? fontSize;
  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.textColor,
    this.textStyle,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = kFontFamily,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPressed();
      },
      child: CustomText(
        text: title,
        textStyle: _getTextStyle(context),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle!;
    } else {
      TextStyle themeTextStyle = Theme.of(context).textTheme.bodyText1!;
      if (textColor != null) {
        themeTextStyle = themeTextStyle.copyWith(color: textColor);
      }
      themeTextStyle = themeTextStyle.copyWith(
        fontFamily: fontFamily,
      );
      themeTextStyle = themeTextStyle.copyWith(
        fontWeight: fontWeight,
      );
      themeTextStyle = themeTextStyle.copyWith(
        fontSize: fontSize != null ? fontSize! : 16.0,
      );

      return themeTextStyle;
    }
  }
}
