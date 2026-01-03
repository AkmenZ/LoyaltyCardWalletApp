import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loyalty_cards_app/theme.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = seed,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      onPressed: onPressed,
      child: child,
      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      ),
      cupertino: (_, __) {
        return CupertinoElevatedButtonData(
          color: backgroundColor,
          sizeStyle: CupertinoButtonSize.small,
        );
      },
    );
  }
}