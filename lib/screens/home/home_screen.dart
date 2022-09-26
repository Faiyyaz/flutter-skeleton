import 'package:flutter/material.dart';

import '../../components/button/custom_text_button.dart';
import '../../components/text/custom_text.dart';
import '../base/base_stateful_widget.dart';

class HomeScreen extends BaseStatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends BaseState<HomeScreen> with BasicPage {
  @override
  Widget getBody(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const CustomText(
          text: 'Home',
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: CustomTextButton(
          onPressed: () async {
            await localStorageService.clear();
          },
          title: 'Logout',
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
