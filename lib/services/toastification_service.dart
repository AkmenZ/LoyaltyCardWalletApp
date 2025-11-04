import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationService {
  // success toast
  static void showSuccess({
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      showProgressBar: true,
    );
  }

  // error toast
  static void showError({
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      showProgressBar: true,
    );
  }

  // info toast
  static void showInfo({
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      showProgressBar: true,
    );
  }

  // warning toast
  static void showWarning({
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      showProgressBar: true,
    );
  }

  // dismiss all toasts
  static void dismissAll() {
    toastification.dismissAll();
  }
}