import 'package:flutter/material.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.lock, size: 100),
          ],
        ),
      ),
    ));
  }
}
