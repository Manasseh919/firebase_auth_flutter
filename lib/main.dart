import 'package:flutter/material.dart';
import 'package:socialmedia/auth/login_or_register.dart';
import 'package:socialmedia/pages/login_page.dart';
import 'package:socialmedia/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
    );
  }
}
