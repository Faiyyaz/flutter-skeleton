import 'package:flutter/material.dart';

class CustomLoaderWidget extends StatelessWidget {
  /// Widget to be shown after loading
  final Widget child;

  /// Boolean to toggle between loaded & loading widget
  final bool showLoader;

  const CustomLoaderWidget({
    Key? key,
    required this.child,
    required this.showLoader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Visibility(
          visible: showLoader,
          child: WillPopScope(
            onWillPop: () async => !showLoader,
            child: IgnorePointer(
              ignoring: !showLoader,
              child: Container(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
