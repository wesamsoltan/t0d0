import 'package:flutter/material.dart';
import 'package:t0d0/style/AppStyle.dart';
import 'package:t0d0/ui/edit_screen/editScreen.dart';
import 'package:t0d0/ui/home/home_screen.dart';
import 'package:t0d0/ui/login/login_screen.dart';
import 'package:t0d0/ui/signup/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t0d0/ui/splash/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FirebaseFirestore.instance.collection('task').add({'title': 'Task 1'});
    print('تم إضافة المستند بنجاح');
  } catch (e) {
    print('حدث خطأ: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppStyle.lightTheme,
      themeMode: ThemeMode.light,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        HomeScreen.routeName:(_) => HomeScreen(),
        SplashScreen.routeName:(_)=>SplashScreen(),
        EditScreen.routeName:(_)=>EditScreen()
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
