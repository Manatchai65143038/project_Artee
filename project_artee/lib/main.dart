import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_artee/model/post.dart';
import 'package:project_artee/page/generate_qr_page.dart';
import 'package:project_artee/page/home_page.dart';
import 'package:project_artee/page/menu_page.dart';
import 'package:project_artee/page/food_statuspage.dart';
import 'package:project_artee/views/login_view.dart';
import 'package:project_artee/page/confirm_payment_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
