import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtils {
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      // animationBuilder: (context, animation, alignment, child) {
      //   return SlideTransition(
      //     position:
      //         Tween<Offset>(
      //           begin: const Offset(1.2, 0), // slide from deep right
      //           end: Offset.zero, // end at center
      //         ).animate(
      //           CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      //         ),
      //     child: child,
      //   );
      // },
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      // animationBuilder: (context, animation, alignment, child) {
      //   return SlideTransition(
      //     position:
      //         Tween<Offset>(
      //           begin: const Offset(1.2, 0), // slide from deep right
      //           end: Offset.zero, // end at center
      //         ).animate(
      //           CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      //         ),
      //     child: child,
      //   );
      // },
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
    );
  }
}
