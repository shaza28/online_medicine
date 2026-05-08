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
}