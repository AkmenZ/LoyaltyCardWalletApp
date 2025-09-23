import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.appBar,
    this.body,
    this.backgroundColor,
  });

  final PlatformAppBar? appBar;
  final Widget? body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      iosContentBottomPadding: true,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      material: (_, __) => MaterialScaffoldData(
        extendBodyBehindAppBar: false,
      ),
      appBar: appBar,
      body: body,
    );
  }
}