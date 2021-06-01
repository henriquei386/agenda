import 'package:agenda/pages/contact_page.dart';
import 'package:flutter/material.dart';
// import 'pages/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ContactPage(),
    );
  }
}
