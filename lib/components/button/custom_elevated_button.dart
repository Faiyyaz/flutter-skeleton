import 'package:flutter/material.dart';
import '../../utilities/ui_constants.dart';

import '../text/custom_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double height;
  final double width;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.height = 35.0,
    this.width = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ElevatedButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width, height),
          maximumSize: Size(double.infinity, height),
        ),
        child: CustomText(
          text: title,
          textStyle: const TextStyle(
            color: kWhiteColor,
            fontFamily: kFontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
