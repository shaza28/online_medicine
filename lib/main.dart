import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_medicine/core/app_data.dart';

void main() async {
  // التأكد من تهيئة الإضافات قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}

