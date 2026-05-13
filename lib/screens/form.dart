import 'package:flutter/material.dart';
import '../core/app_data.dart';

class FormScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController? nameController; // أضفته ليناسب شاشة التسجيل [cite: 49]
  final bool isSignup; // للتفرقة بين اللوجن والتسجيل [cite: 16]

  const FormScreen({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.nameController,
    this.isSignup = false, // الوضع الافتراضي لوجن
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool isObscure = true;

  // --- دمج دوال الفليداشن التي أرسلتِها ---

  String? _validateName(String? value) =>
      (value == null || value.isEmpty) ? 'Please enter your name' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!value.contains('@') || !value.contains('.')) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != widget.passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // حقل الاسم يظهر فقط في حالة التسجيل
          if (widget.isSignup) ...[
            TextFormField(
              controller: widget.nameController,
              cursorColor: AppColors.blue,
              validator: _validateName,
              decoration: _buildInputDecoration("Enter Your Name", Icons.person_outline),
            ),
            const SizedBox(height: 16),
          ],

          // حقل الإيميل [cite: 30, 41, 50, 64]
          TextFormField(
            controller: widget.emailController,
            cursorColor: AppColors.blue,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            decoration: _buildInputDecoration("Enter Your Email", Icons.email_outlined),
          ),

          const SizedBox(height: 16),

          // حقل الباسورد [cite: 31, 42, 51, 65]
          TextFormField(
            controller: widget.passwordController,
            obscureText: isObscure,
            cursorColor: AppColors.blue,
            validator: _validatePassword,
            decoration: _buildInputDecoration(
              "Enter Your Password",
              Icons.lock_outline_rounded,
              isPassword: true,
            ),
          ),

          // حقل تأكيد الباسورد يظهر فقط في حالة التسجيل [cite: 52, 66]
          if (widget.isSignup) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: isObscure,
              cursorColor: AppColors.blue,
              validator: _validateConfirmPassword,
              decoration: _buildInputDecoration(
                "Confirm Password",
                Icons.lock_reset_rounded,
                isPassword: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // دالة مساعدة لبناء الـ Decoration لتقليل تكرار الكود
  InputDecoration _buildInputDecoration(String hint, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: isPassword
          ? IconButton(
        onPressed: () => setState(() => isObscure = !isObscure),
        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
      )
          : null,
      fillColor: AppColors.white,
      filled: true,
      hintText: hint,
      enabledBorder: _buildBorder(AppColors.white),
      focusedBorder: _buildBorder(AppColors.white),
      errorBorder: _buildBorder(Colors.red),
      focusedErrorBorder: _buildBorder(Colors.red),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(16),
    );
  }
}









/*
import 'package:flutter/material.dart';
import 'package:online_medicine/core/app_data.dart';

class FormScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const FormScreen({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}
class _FormScreenState extends State<FormScreen> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [

          TextFormField(
            controller: widget.emailController,
            cursorColor: AppColors.blue,
            keyboardType: TextInputType.emailAddress,

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your email";
              }

              bool isValidEmail = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value);

              if (!isValidEmail) {
                return "Enter a valid email";
              }

              return null;
            },

            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              fillColor: AppColors.white,
              filled: true,
              hintText: "Enter Your Email",
              enabledBorder: _buildBorder(AppColors.white),
              focusedBorder: _buildBorder(AppColors.white),
              errorBorder: _buildBorder(Colors.red),
              focusedErrorBorder: _buildBorder(Colors.red),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: widget.passwordController,
            obscureText: isObscure,
            cursorColor: AppColors.blue,

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your password";
              }

              bool isValidPassword = RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
              ).hasMatch(value);

              if (!isValidPassword) {
                return "Password must contain:\nUppercase, lowercase, number & special character";
              }

              return null;
            },

            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline_rounded),

              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),

              fillColor: AppColors.white,
              filled: true,
              hintText: "Enter Your Password",
              enabledBorder: _buildBorder(AppColors.white),
              focusedBorder: _buildBorder(AppColors.white),
              errorBorder: _buildBorder(Colors.red),
              focusedErrorBorder: _buildBorder(Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(16),
    );
  }
}*/
