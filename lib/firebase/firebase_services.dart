import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_medicine/screens/models/user_models.dart';

class FirebaseService {
  static Future<UserCredential> register(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<UserCredential> login(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<void>addUserToFireStore(UserModel user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> usersCollection = db.collection(
      "Users",
    );
    DocumentReference<Map<String, dynamic>> usersDocument = usersCollection
        .doc(user.id);
    return usersDocument.set({"id":user.id,
      "email":user.email,
      "name":user.name,

    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
   return FirebaseFirestore.instance.collection("Users").doc(uid).snapshots();
  }
}
