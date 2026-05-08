import 'package:firebase_auth/firebase_auth.dart'; // ✅ إضافة مكتبة الفايربيز
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_medicine/core/app_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // 1. انتظار لمدة ثانيتين لعرض اللوجو
    await Future.delayed(const Duration(seconds: 2));

    // 2. جلب حالة الـ Onboarding وحالة المستخدم من الفايربيز
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    // فحص هل فيه مستخدم مسجل دخول حالياً؟
    final User? user = FirebaseAuth.instance.currentUser;

    if (mounted) {
      if (!onboardingSeen) {
        // حالة (أ): أول مرة يفتح التطبيق -> يروح Onboarding
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingScreen);
      } else {
        // حالة (ب): شاف الـ Onboarding قبل كدة، نتحقق من الدخول
        if (user != null) {
          // مسجل دخول فعلاً -> يروح Home
          Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        } else {
          // مش مسجل دخول -> يروح Login
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // التصميم زي ما هو بالظبط بدون أي تغيير
      backgroundColor: AppColors.gradiantGreen,
      body: Center(
        child: Image.asset(AppImages.logo),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //
import 'package:online_medicine/core/app_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation(); // تغيير اسم الدالة للتوضيح
  }

  /// دالة للتحكم في المسار بناءً على حالة المستخدم
  Future<void> _handleNavigation() async {
    // انتظار لمدة ثانيتين لعرض اللوجو
    await Future.delayed(const Duration(seconds: 2));

    // جلب تفضيلات المستخدم من الجهاز
    final prefs = await SharedPreferences.getInstance();

    // التأكد إذا كان المستخدم قد شاهد صفحات التقديم سابقاً
    // إذا كانت القيمة null (أول مرة)، نعتبرها false
    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    if (mounted) {
      if (onboardingSeen) {
        // إذا شاهدها من قبل، اذهب للـ Login مباشرة
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } else {
        // إذا كانت أول مرة، اذهب للـ Onboarding
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الحفاظ على لون الخلفية واللوجو الخاص بكِ
      backgroundColor: AppColors.gradiantGreen,
      body: Center(
        child: Image.asset(AppImages.logo),
      ),
    );
  }
}*/
