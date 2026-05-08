import 'package:flutter/cupertino.dart';
import 'package:online_medicine/screens/splash_screen.dart';

import '../screens/home_screen.dart';
import '../screens/login.dart';
import '../screens/onboading_screen.dart';
import '../screens/register.dart';

class AppImages {
  AppImages._();
  static const String base = "assets/images";
  static const String logo = "$base/logo.png";
  static const String smallLogo = "$base/small_logo.png";
  static const String onboardingOne = "$base/onboarding_one.png";
  static const String onboardingTwo = "$base/onboarding_two.png";
  static const String onboardingThree = "$base/onboarding_three.png";
  static const String iconArrow = "$base/Icon_arrow.png";
  static const String googleIcon= "$base/gogle_icon.png";


}
class AppColors{
  AppColors._();
  static const Color white=Color(0xFFFFFFFF);
  static const Color gradiantGreen=Color( 0xFFDDEEEF);
  static const Color blue=Color(0xFF90C2F3);
  static const Color whiteGreen=Color(0xFFE3F2FD);
  }



class AppRoutes{

static const String splashScreen="/splash";
static const String onboardingScreen="/onboarding";
static const String loginScreen="/login";
static const String homeScreen="/home";
static const String registerScreen="/register";

  static Map<String,WidgetBuilder>routes={
    splashScreen:(context)=>SplashScreen(),
    loginScreen:(context)=>LoginScreen(),
    homeScreen:(context)=>HomeScreen(),
    registerScreen:(context)=>RegisterScreen(),
    onboardingScreen:(context)=>OnboardingScreen(),




  };


}