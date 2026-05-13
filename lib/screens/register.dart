import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/ui_utils.dart';
import '../firebase/firebase_services.dart';
import 'form.dart';
import 'models/user_models.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          },
          icon: Icon(
            Icons.arrow_circle_left_outlined,
            color: AppColors.blue,
            size: 30,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: AppColors.blue.withOpacity(0.5),
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppImages.smallLogo),
                      const Text(
                        "Create Account", //
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2652),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Join us to start your journey\ntowards better health care",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      // ✅ استخدام الفورم مع تفعيل خاصية isSignup لإظهار حقل الاسم والتأكيد [cite: 52, 63, 66]
                      FormScreen(
                        formKey: _registerKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        nameController: _nameController,
                        isSignup: true,
                      ),
                      const SizedBox(height: 20),

                      // زر إنشاء الحساب بالجرادينت [cite: 54, 67, 128]
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            createAccount();
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen); //
                        },
                        child: const Text(
                          "Already Have Account? Login",
                          style: TextStyle(color: Colors.white),
                        ),
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

  void createAccount() async {
    // 1. التأكد من الـ Validation [cite: 56, 57]
    if (_registerKey.currentState?.validate() ?? false) {
      try {
        if (!mounted) return;

        UIUtils.showLoading(context, isDismissible: false); // [cite: 36]

        // 2. محاولة إنشاء الحساب في Firebase Auth [cite: 58, 92]
        UserCredential userCredential = await FirebaseService.register(
          _emailController.text.trim(),
          _passwordController.text,
        );

        // 3. تجهيز بيانات المستخدم وحفظها في Firestore (Bonus)
        UserModel user = UserModel(
            id: userCredential.user!.uid,
            name: _nameController.text.trim(),
            email: _emailController.text.trim()
        );

        await FirebaseService.addUserToFireStore(user); // [cite: 96]

        if (!mounted) return;
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("Successful Registration", Colors.green);

        // 4. الانتقال للوجن بعد النجاح [cite: 55]
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } on FirebaseAuthException catch (exception) {
        if (!mounted) return;
        UIUtils.hideDialog(context);

        // التعامل مع أخطاء فايربيز [cite: 37, 98]
        String message = "Registration Failed";
        if (exception.code == 'email-already-in-use') {
          message = "This email is already registered";
        } else if (exception.code == 'weak-password') {
          message = "The password is too weak";
        }

        UIUtils.showToastMessage(message, Colors.red);
      } catch (exception) {
        if (!mounted) return;
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("An error occurred", Colors.red);
      }
    }
  }
}