import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:t0d0/ui/home/home_screen.dart';
import 'package:t0d0/ui/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "Splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser==null){
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }else{
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          height: height * 0.5,
          width: width * 0.4,
        ),
      ).animate().scaleX(duration: Duration(seconds: 4)),
    );
  }
}
