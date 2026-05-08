import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_medicine/core/ui_utils.dart';
import 'package:online_medicine/firebase/firebase_services.dart';
import 'package:online_medicine/screens/models/user_models.dart';

import '../core/app_data.dart';
import 'form.dart';

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

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController=TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
_nameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          },
          child: Icon(
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
              // 2. الكارد
              Card(
                color: AppColors.blue.withOpacity(
                  0.5,
                ), // خليته شفاف شوية زي ما كنتِ عاملة
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
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2652),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Create an account to start your journey!\n towards better health care",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      // الفورم المنفصل
                      FormScreen(
                        formKey: _registerKey,
                        emailController:
                            _emailController, // ✅ مررنا الكنترولر الخاص بالإيميل
                        passwordController:
                            _passwordController, // ✅ مررنا الكنترولر الخاص بالباسورد
                      ),
                      const SizedBox(height: 20),

                      // زرار الدخول بالجرادينت
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
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4EBCE8).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
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
                            // لو البيانات صحيحة، الكود اللي هنا هيتنفذ
                            print("Validation Success!");
                            createAccount();
                          },

                          // قوس واحد يقفل الـ onPressed
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Already Have Account ? Login",
                          style: TextStyle(color: AppColors.white),
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

  Widget _socialMediaIcon({required Widget child}) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(child: child),
    );
  }

  void createAccount() async {
    // 1. التأكد من الـ Validation
    if (_registerKey.currentState?.validate() ?? false) {
      try {
        // التحقق إن الـ widget لسه موجود قبل استخدام الـ context
        if (!mounted) return;

        UIUtils.showLoading(context, isDismissible: false);

        // محاولة إنشاء الحساب
        UserCredential userCredential = await FirebaseService.register(
          _emailController.text.trim(),
          _passwordController.text,
        );
        String extractedName = _emailController.text.split('@')[0];

        // التحقق مرة تانية قبل قفل الدايلوج والانتقال
        if (!mounted) return;
        UserModel user=UserModel(id:userCredential.user!.uid, name: extractedName, email: _emailController.text.trim());
        await FirebaseService.addUserToFireStore(user);
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("Successful Registration", Colors.green);

        // الانتقال للوجن
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } on FirebaseAuthException catch (exception) {
        if (!mounted) return;
        UIUtils.hideDialog(context);

        // التعامل مع أخطاء فايربيز المشهورة
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
        UIUtils.showToastMessage(
          "An error occurred: ${exception.toString()}",
          Colors.red,
        );
      }
    }
  }

  /*void createAccount() async {
    if (_registerKey.currentState!.validate()) {
      try {
        UIUtils.showLoading(context, isDismissible: false);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("Successful Registration", Colors.green);
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);

      } on FirebaseAuthException catch (exception) {
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage(exception.code, Colors.red);
      } catch (exception) {
        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("Failed To Register", Colors.red);

      }
    }
  }*/
}
