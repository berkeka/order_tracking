import 'package:flutter/material.dart';
import 'package:order_tracking/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // If user is authenticated render Home
    // Else render authentication window
    return Home();
  }
}
