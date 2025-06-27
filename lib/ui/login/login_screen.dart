import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t0d0/firebase/FirebaseAuthCodes.dart';
import 'package:t0d0/style/DialogUtils.dart';
import 'package:t0d0/ui/home/home_screen.dart';
import 'package:t0d0/ui/signup/register_screen.dart';

import '../../style/reusable_components/CustomButton.dart';
import '../../style/reusable_components/CustomFormField.dart';
import '../../style/reusable_components/Validtion.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/back.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Login"),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Customformfield(
                      label: "Email Adress",
                      keyboard: TextInputType.emailAddress,
                      controller: emailController,
                      Validator: Validation.emailValidator,
                    ),
                    SizedBox(height: height * 0.02),
                    Customformfield(
                      label: "Password",
                      keyboard: TextInputType.visiblePassword,
                      controller: passwordController,
                      isPassword: true,
                      Validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "enter your password";
                        }
                        if (value.length > 8) {
                          return "password shouldn't be less than 8 characters";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: height * 0.06),
                    Custombutton(
                      onPress: () {
                        login();
                      },
                      title: "login acount",
                    ),
                    SizedBox(height: height * 0.06),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Text("create account"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      //login for account
      try {
        Dialogutils.Showloading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,(route)=>false);
        print("sign in success:${userCredential.user?.uid}");
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == Firebaseauthcodes.userNotFound) {
          Dialogutils.ShowMessageDialog(
              context,
              message: 'no user found for that email',
               positiveActionTitle: "ok",
          positiveActionClick:(){
            Navigator.pop(context);
          } );
        } else if (e.code == Firebaseauthcodes.wrongPassword)
        {Dialogutils.ShowMessageDialog(
            context,
            message: 'Wrong password provided for that user.',
            positiveActionTitle: "ok",
            positiveActionClick:(){
              Navigator.pop(context);
            } );
        }
      }
    }
  }
}
