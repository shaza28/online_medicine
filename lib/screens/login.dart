import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_medicine/core/app_data.dart';
import 'package:online_medicine/core/ui_utils.dart';
import 'package:online_medicine/firebase/firebase_services.dart';
import 'package:online_medicine/screens/form.dart';
import 'package:online_medicine/screens/models/user_models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: AppColors.blue.withOpacity(0.5),
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppImages.smallLogo),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E2652)),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "We’re happy to see you again!\nPlease enter your details.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      FormScreen(
                        formKey: _loginFormKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF49D6A5), Color(0xFF4EBCE8)],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: login,
                          child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1, endIndent: 10)),
                          const Text("Or"),
                          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1, indent: 10)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ✅ التصليح هنا: فصل أيقونة جوجل عشان الـ Navigator ميضربش
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: googleSignIn, // بننادي الدالة وهي اللي بتعمل Navigate لو نجحت
                            child: _socialMediaIcon(
                              child: Image.asset(AppImages.googleIcon, height: 30),
                            ),
                          ),
                          const SizedBox(width: 20),
                          _socialMediaIcon(child: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 35)),
                          const SizedBox(width: 20),
                          _socialMediaIcon(child: const Icon(Icons.apple, color: Colors.black, size: 35)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.registerScreen),
                        child: const Text("Don’t have an account? Sign Up", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        UIUtils.showLoading(context, isDismissible: false);
        await FirebaseService.login(_emailController.text.trim(), _passwordController.text);
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("User Logged-In Successfully", Colors.green);
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      } on FirebaseAuthException catch (e) {
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("Invalid Email or Password", Colors.red);
      } catch (e) {
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("Failed to login", Colors.red);
      }
    }
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: "385345935045-qea2cvko87ikmb054fq18i2ae6uvvop3.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      UIUtils.showLoading(context, isDismissible: false);
      UserCredential firebaseUser = await FirebaseAuth.instance.signInWithCredential(credential);

      UserModel finalUser = UserModel(
          id: firebaseUser.user?.uid ?? " ",
          email: firebaseUser.user?.email ?? "No email provided",
          name: firebaseUser.user?.displayName ?? "No name provided"
      );

      await FirebaseService.addUserToFireStore(finalUser);
      UIUtils.hideDialog(context);

      if (mounted) {
        UIUtils.showToastMessage("User Logged-In Successfully", Colors.green);
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      }
    } catch (exception) {
      UIUtils.hideDialog(context);
      log("Detailed Error: ${exception.toString()}");
      UIUtils.showToastMessage("Google Sign-In Failed", Colors.red);
    }
  }

  Widget _socialMediaIcon({required Widget child}) {
    return Container(
      width: 55, height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(child: child),
    );
  }
}