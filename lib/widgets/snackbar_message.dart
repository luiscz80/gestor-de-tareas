import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message,
    {int durationSeconds = 2}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', width: 24, height: 24),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              '$message',
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withOpacity(0.8),
      duration: Duration(seconds: durationSeconds),
    ),
  );

  // Cerrar el mensaje después de 2 segundo
  Future.delayed(Duration(seconds: 2), () {
    if (scaffoldMessenger.mounted) {
      scaffoldMessenger.hideCurrentSnackBar();
    }
  });
}
