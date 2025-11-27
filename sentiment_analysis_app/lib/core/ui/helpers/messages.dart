import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin Messages<T extends StatefulWidget> on State<T> {
  void showError(String message) {
    _showToast(
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showWarning(String message) {
    _showToast(
      message: message,
      icon: Icons.warning,
      backgroundColor: Colors.yellow,
      textColor: Colors.black,
    );
  }

  void showInfo(String message) {
    _showToast(
      message: message,
      icon: Icons.info,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  void showSuccess(String message) {
    _showToast(
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _showToast({
    required String message,
    IconData? icon,
    required Color backgroundColor,
    required Color textColor,
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: textColor,
            ),
            const SizedBox(width: 12.0),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16.0,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: duration,
      gravity: gravity,
    );
  }
}
