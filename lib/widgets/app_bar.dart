import 'package:flutter/material.dart';
import 'package:tareas/screens/login_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuthenticated;
  final VoidCallback appLockCallback;

  MyAppBar({required this.isAuthenticated, required this.appLockCallback});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 16),
          Image.asset(
            'assets/logo.png',
            height: 44,
          ),
          Spacer(),
          Text(
            'Gestor de Tareas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: Icon(
                isAuthenticated ? Icons.lock_open : Icons.lock,
                color: const Color.fromARGB(255, 251, 217, 27),
                size: 32.0,
              ),
              onPressed: isAuthenticated
                  ? () {
                      appLockCallback();
                      _navigateToLoginScreenWithAnimation(context);
                    }
                  : () {
                      _navigateToLoginScreenWithAnimation(context);
                    },
            ),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  void _navigateToLoginScreenWithAnimation(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }
}
