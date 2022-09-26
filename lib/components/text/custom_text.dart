import 'package:flutter/material.dart';
import '../../utilities/ui_constants.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextStyle? textStyle;
  final String fontFamily;
  final FontWeight fontWeight;
  final double? fontSize;
  final TextAlign textAlign;
  final int? maxLines;
  final Map<String, String>? args;

  const CustomText({
    Key? key,
    required this.text,
    this.color,
    this.textStyle,
    this.fontFamily = kFontFamily,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.fontSize,
    this.maxLines,
    this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getText(text),
      textAlign: textAlign,
      maxLines: maxLines,
      style: _getTextStyle(context),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle!;
    } else {
      TextStyle themeTextStyle = Theme.of(context).textTheme.bodyText1!;
      if (color != null) {
        themeTextStyle = themeTextStyle.copyWith(color: color);
      }
      themeTextStyle = themeTextStyle.copyWith(
        fontFamily: fontFamily,
      );
      themeTextStyle = themeTextStyle.copyWith(
        fontWeight: fontWeight,
      );
      themeTextStyle = themeTextStyle.copyWith(
        fontSize: fontSize ?? 16.0,
      );

      return themeTextStyle;
    }
  }

  String _getText(String? text) {
    if (text != null) {
      return text;
    } else {
      return '';
    }
  }
}
