import '../../utilities/ui_constants.dart';
import '../text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final bool hideText;
  final int? maxLines;
  final int? maxCount;
  final String? error;
  final String placeholder;
  final Widget? suffix;

  const CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.onChanged,
    required this.placeholder,
    this.keyboardType = TextInputType.text,
    this.hideText = false,
    this.maxLines,
    this.maxCount,
    this.error,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          onChanged: onChanged,
          controller: textEditingController,
          keyboardType: keyboardType,
          obscureText: hideText,
          maxLines: hideText ? 1 : maxLines,
          minLines: hideText ? 1 : maxLines,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: suffix,
            counterText: '',
            hintText: placeholder,
          ),
        ),
        Visibility(
          visible: error != null,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CustomText(
              text: error,
              color: kRedColor,
            ),
          ),
        )
      ],
    );
  }
}
