import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // === REGISTER ===
  Future<String?> register(String email, String password, String username) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // SIMPAN KE FIRESTORE
      await _db.collection("users").doc(cred.user!.uid).set({
        "username": username,
        "email": email,
        "score": 0,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // === LOGIN ===
  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // === GET USERNAME ===
  Future<String> getUsername() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _db.collection("users").doc(uid).get();

    if (!doc.exists) return "Player";
    return doc['username'] ?? "Player";
  }

//score 
  Future<void> updateScore(int newScore) async {
  final uid = _auth.currentUser!.uid;
  await _db.collection("users").doc(uid).update({
    "score": newScore,
  });
}
Stream<QuerySnapshot> getRankings() {
  return _db
      .collection("users")
      .orderBy("score", descending: true)
      .limit(10)
      .snapshots();
}


}
