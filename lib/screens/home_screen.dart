import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC), // خلفية هادئة [cite: 23]

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
            'Home Page',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        actions: [
          // زر تسجيل الخروج المطلوب [cite: 74, 83, 93, 134]
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // [cite: 77, 93]
              Navigator.pushReplacementNamed(context, '/login'); // العودة للـ Login [cite: 77]
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. رسالة ترحيب (Welcome message) [cite: 72, 81, 132]
            const Text(
                'Welcome back!',
                style: TextStyle(fontSize: 16, color: Colors.grey)
            ),

            // 2. عرض اسم المستخدم من Firestore (Bonus requirement)
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseService.getUserData(),
              builder: (context, snapshot) {
                String name = snapshot.data?.data()?['name'] ?? "User";
                return Text(
                    name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))
                );
              },
            ),

            const SizedBox(height: 30),

            // 3. كارت معلومات المستخدم (User information card) [cite: 82, 133]
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xffEAF3FF),
                    child: Icon(Icons.person, size: 45, color: Color(0xff5EA8F2)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Registered Email', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 5),

                  // عرض الإيميل (Display user email) [cite: 73, 133]
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? "No Email Found",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
                ),
                child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// home
/// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         height: 70,
//         width: 70,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: const LinearGradient(
//             colors: [Color(0xff5EA8F2), Color(0xff6ED6C2)],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(.3),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: const Icon(Icons.qr_code_scanner,
//             color: Colors.white, size: 28),
//       ),
//
//       bottomNavigationBar: const BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 8,
//         child: SizedBox(
//           height: 65,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Icon(Icons.home, color: Colors.blue),
//               Icon(Icons.local_pharmacy_outlined, color: Colors.grey),
//               SizedBox(width: 40),
//               Icon(Icons.local_shipping_outlined, color: Colors.grey),
//               Icon(Icons.chat_bubble_outline, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 const SizedBox(height: 10),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                             radius: 16,
//                             child: Icon(Icons.person, size: 18)
//                         ),
//                         const SizedBox(width: 10),
//
//                         // ✅ التعديل هنا: جلب الاسم ديناميكياً من Firestore
//                         StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                           stream: FirebaseService.getUserData(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) return const Text('Error');
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return const Text('Loading...');
//                             }
//
//                             // جلب الحقل 'name' اللي خزنناه وقت الـ Register
//                             String name = snapshot.data?.data()?['name'] ?? "User";
//
//                             return Text(
//                               ' $name',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                                 color: Color(0xFF1E293B),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     const Row(
//                       children: [
//                         Icon(Icons.calendar_today_outlined),
//                         SizedBox(width: 12),
//                         Icon(Icons.notifications_none),
//                       ],
//                     )
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     color: const Color(0xffEAF3FF),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: const Color(0xff5EA8F2)),
//                   ),
//                   child: const Column(
//                     children: [
//                       Text('Upload Prescription',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       Text(
//                         'Upload a Prescription and Tell Us what you Need.\nWe do the Rest.!',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 13),
//                       ),
//                       SizedBox(height: 15),
//                       SizedBox(
//                         height: 45,
//                         child: Center(
//                           child: Text(
//                             'Order Now',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xff6ED6C2), Color(0xff5EA8F2)],
//                     ),
//                   ),
//                   child: const Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('UPTO 80%',
//                                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                             Text('OFFER'),
//                             SizedBox(height: 6),
//                             Text('On Health Products'),
//                             SizedBox(height: 10),
//                             Text('Shop Now',
//                                 style: TextStyle(color: Colors.white)),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(Icons.local_hospital, color: Colors.white, size: 60),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 sectionTitle('Popular Product'),
//                 const SizedBox(height: 10),
//                 productList(),
//
//                 const SizedBox(height: 20),
//
//                 sectionTitle('Product on Sale'),
//                 const SizedBox(height: 10),
//                 productList(isSale: true),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget sectionTitle(String title) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title,
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 18)),
//         const Text('See all',
//             style: TextStyle(color: Color(0xff5EA8F2))),
//       ],
//     );
//   }
//
//   Widget productList({bool isSale = false}) {
//     return SizedBox(
//       height: 170,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) =>
//             ProductCard(index: index, isSale: isSale),
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemCount: 3,
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final bool isSale;
//   final int index;
//
//   ProductCard({super.key, required this.index, this.isSale = false});
//
//   final List<String> images = [
//     "https://images.unsplash.com/photo-1584362917165-526a968579e8",
//     "https://images.unsplash.com/photo-1603398938378-e54eab446dde",
//     "https://images.unsplash.com/photo-1587854692152-cbe660dbde88",
//   ];
//
//   final List<String> names = [
//     "Panadol",
//     "Aspirin",
//     "Vitamin C",
//   ];
//
//   final List<double> prices = [
//     15.99,
//     12.50,
//     9.99,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProductPage(
//               image: images[index],
//               name: names[index],
//               price: prices[index],
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 130,
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 images[index],
//                 height: 60,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             Text(names[index],
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//
//             const Text('20pcs',
//                 style: TextStyle(color: Colors.grey, fontSize: 12)),
//
//             const SizedBox(height: 6),
//
//             Text(
//               "\$${prices[index].toStringAsFixed(2)}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




/*

 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_medicine/core/app_data.dart';
import '../firebase/firebase_services.dart';
import 'product_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // الجزء الخاص بـ AppBar لإضافة زر Logout [cite: 74, 83]
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              // تنفيذ عملية تسجيل الخروج [cite: 77, 93]
              await FirebaseAuth.instance.signOut();
              // العودة لشاشة تسجيل الدخول ومسح التاريخ [cite: 77]
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70, width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xff5EA8F2), Color(0xff6ED6C2)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(.3),
              blurRadius: 10, offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),

    */
/*  bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.home, color: Colors.blue),
              Icon(Icons.local_pharmacy_outlined, color: Colors.grey),
              SizedBox(width: 40),
              Icon(Icons.local_shipping_outlined, color: Colors.grey),
              Icon(Icons.chat_bubble_outline, color: Colors.grey),
            ],
          ),
        ),
      ),*//*


      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // الهيدر المحدث لعرض رسالة الترحيب والاسم [cite: 72, 73, 81]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xffEAF3FF),
                            child: Icon(Icons.person, size: 22, color: Color(0xff5EA8F2))
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome 👋', // رسالة ترحيب [cite: 72, 132]
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseService.getUserData(),
                              builder: (context, snapshot) {
                                String name = snapshot.data?.data()?['name'] ?? "User";
                                return Text(
                                  name, // عرض الاسم [cite: 73, 97]
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF1E293B),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 20),
                        SizedBox(width: 12),
                        Icon(Icons.notifications_none, size: 24),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 25),

                // الكارت الخاص بالبيانات (User Information Card) [cite: 82, 133]
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8FAFC),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, color: Color(0xff5EA8F2)),
                      const SizedBox(width: 10),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? "", // عرض الإيميل [cite: 73]
                        style: const TextStyle(color: Color(0xff64748B)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ... باقي التصميم الخاص بك (Prescription, Offers, Products) يظل كما هو دون تغيير
                // [يتبع نفس الكود السابق الخاص بالمنتجات]
              ],
            ),
          ),
        ),
      ),
    );
  }

// الدوال المساعدة (sectionTitle & productList) تظل كما هي
}*/
