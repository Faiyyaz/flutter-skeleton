import 'package:flutter/material.dart';

import '../../components/button/custom_text_button.dart';
import '../../components/text/custom_text.dart';
import '../../services/local_storage_service.dart';
import '../base/base_stateful_widget.dart';

class LoginScreen extends BaseStatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends BaseState<LoginScreen> with BasicPage {
  @override
  Widget getBody(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const CustomText(
          text: 'Login',
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: CustomTextButton(
          onPressed: () async {
            await localStorageService.setValue(
              key: kTokenKey,
              value: "fake_token",
            );
          },
          title: 'Login',
        ),
      ),
    );
  }

  @override
  bool onBackPress() {
    return true;
  }

  @override
  bool shouldShowLoader() {
    return false;
  }
}
