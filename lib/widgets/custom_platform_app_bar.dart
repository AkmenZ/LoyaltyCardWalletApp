import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;

class CustomPlatformAppBar extends PlatformAppBar {
  CustomPlatformAppBar({
    super.key,
    required Widget super.title,
    super.leading,
    List<Widget> super.trailingActions = const [],
  }) : super(
          material: (_, __) => MaterialAppBarData(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          cupertino: (context, __) => CupertinoNavigationBarData(
            transitionBetweenRoutes: true,
            automaticBackgroundVisibility: false,
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5, // tweak to 0.33 for an even finer hairline
              ),
            ),
          ),
        );
}