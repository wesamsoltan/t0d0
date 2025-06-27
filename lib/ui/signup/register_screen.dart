import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t0d0/firebase/FirebaseAuthCodes.dart';
import 'package:t0d0/firebase/FirestoreHandler.dart';
import 'package:t0d0/style/DialogUtils.dart';
import 'package:t0d0/style/reusable_components/CustomButton.dart';
import 'package:t0d0/style/reusable_components/CustomFormField.dart';
import 'package:t0d0/style/reusable_components/Validtion.dart';
import 'package:t0d0/ui/home/home_screen.dart';
import 'package:t0d0/firebase/model/User.dart' as my_user;

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    ageController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Create Account"),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
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
                      label: "Full Name",
                      keyboard: TextInputType.name,
                      controller: nameController,
                      Validator: (value) {
                        return Validation.fullNameValidator(
                          value,
                          "enter your name",
                        );
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    Customformfield(
                      label: "Email Address",
                      keyboard: TextInputType.emailAddress,
                      controller: emailController,
                      Validator: Validation.emailValidator,
                    ),
                    SizedBox(height: height * 0.02),
                    Customformfield(
                      label: "age",
                      keyboard: TextInputType.number,
                      controller: ageController,
                      Validator: (value) {
                        return Validation.ageValidator(value, "enter your age");
                      },
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
                        if (value.length < 8) {
                          return "password should be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    Customformfield(
                      label: "Password Confirmation",
                      keyboard: TextInputType.visiblePassword,
                      controller: passwordConfirmController,
                      isPassword: true,
                      Validator: (value) {
                        if (value != passwordController.text) {
                          return "mismatch with password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height *  0.06),
                    Custombutton(
                      onPress: () {
                        CreateAcount();
                      },
                      title: "Create Account",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  CreateAcount() async {
    if (formKey.currentState!.validate()) {
      try {
        Dialogutils.Showloading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(

              email: emailController.text,
              password: passwordController.text,
            );
        await FirestoreHandler.createUser(
          my_user.User(
            uid: userCredential.user!.uid,
            age: int.parse(ageController.text),
            email: emailController.text,
            fullName: nameController.text,
          ),
        );
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      } on FirebaseAuthException catch (error) {
        Navigator.pop(context);
        if (error.code == Firebaseauthcodes.weakpass) {
          Dialogutils.ShowMessageDialog(
            context,
            message: 'The password provided is too weak.',
            positiveActionTitle: "ok",
            positiveActionClick: () {
              Navigator.pop(context);
            },
          );
        } else if (error.code == Firebaseauthcodes.emailAlreadyInUse) {
          Dialogutils.ShowMessageDialog(
            context,
            message: 'The account already exists for that email.',
            positiveActionTitle: "ok",
            positiveActionClick: () {
              Navigator.pop(context);
            },
          );
        }
      } catch (error) {
        print(error);
      }
    }
  }
}
