import 'package:flutter/material.dart';

import '../../components/text/custom_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: const Center(
        child: CustomText(
          text: 'Skeleton',
          fontWeight: FontWeight.bold,
          fontSize: 50.0,
        ),
      ),
    );
  }
}
