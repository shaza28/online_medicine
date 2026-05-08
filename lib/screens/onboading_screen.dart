import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // تأكدي من إضافة المكتبة في pubspec.yaml
import 'package:online_medicine/core/app_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> data = [
    {
      "title": "Your Pharmacy, Anywhere",
      "desc": "Access thousands of medicines and healthcare products with just a tap. Professional care delivered to your door.",
      "image": AppImages.onboardingOne,
    },
    {
      "title": "Scan & Order in Seconds",
      "desc": "Simply upload your prescription, and we’ll handle the rest. No more waiting in long pharmacy queues.",
      "image": AppImages.onboardingTwo,
    },
    {
      "title": "Fast & Safe Delivery",
      "desc": "Get your medicine delivered to your doorstep within minutes, with real-time tracking and expert care.",
      "image": AppImages.onboardingThree,
    },
  ];

  /// دالة حفظ الحالة والانتقال لشاشة اللوجن
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true); // حفظ أن المستخدم أتم الـ Onboarding

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🔹 1. الخلفية (المنحنى الأزرق في الأسفل)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: OnboardingClipper(),
              child: Container(
                height: size.height * 0.48,
                color: const Color(0xFFE9F7F9),
              ),
            ),
          ),

          /// 🔹 2. الصور (PageView)
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.all(40),
                        child: Image.asset(
                          data[i]["image"]!,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),

          /// 🔹 3. المحتوى العلوي (اللوجو + النصوص + الأزرار)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  /// اللوجو الثابت في الأعلى
                  Center(
                    child: Image.asset(
                      AppImages.smallLogo,
                      height: 45,
                    ),
                  ),

                  const Spacer(),

                  /// النصوص المتغيرة بناءً على الصفحة
                  Text(
                    data[currentIndex]["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    data[currentIndex]["desc"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🔹 الأزرار والمؤشرات
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // المؤشر وكلمة Skip
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: List.generate(
                                data.length,
                                    (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 5),
                                  height: 6,
                                  width: currentIndex == index ? 20 : 6,
                                  decoration: BoxDecoration(
                                    color: currentIndex == index
                                        ? const Color(0xFF48C9B0)
                                        : const Color(0xFFD1D5DB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _completeOnboarding, // استدعاء دالة الحفظ عند التخطي
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                    color: Color(0xFF48C9B0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),

                        // زر التالي / البدء (Get started)
                        GestureDetector(
                          onTap: () {
                            if (currentIndex == data.length - 1) {
                              _completeOnboarding(); // حفظ الحالة والانتقال للوجن في آخر صفحة
                            } else {
                              _controller.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            }
                          },
                          child: currentIndex == data.length - 1
                              ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF48C9B0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "Get started",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          )
                              : Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFF48C9B0).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF48C9B0),
                                  width: 1.5),
                            ),
                            child: const Icon(Icons.arrow_forward_ios,
                                size: 18, color: Color(0xFF48C9B0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// الـ Clipper الخاص برسم المنحنى في الخلفية
class OnboardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 60);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}