import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.appBar,
    this.bottomNavBar,
    this.body,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = false,
  });

  final PlatformAppBar? appBar;
  final PlatformNavBar? bottomNavBar;
  final Widget? body;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      iosContentBottomPadding: true,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      material: (_, __) => MaterialScaffoldData(
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset
      ),
      cupertino: (_, __) => CupertinoPageScaffoldData(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
      appBar: appBar,
      body: body,
      bottomNavBar: bottomNavBar,
    );
  }
}