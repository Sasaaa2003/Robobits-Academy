import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveScore(String level, int newScore) async {
    final uid = _auth.currentUser!.uid;
    final ref = _db.collection("users").doc(uid);

    await _db.runTransaction((transaction) async {
      final snap = await transaction.get(ref);

      int oldLevelScore = 0;
      int oldTotal = 0;

      if (snap.exists) {
        final data = snap.data()!;

        oldLevelScore = data["levelScore"]?[level] ?? 0;
        oldTotal = data["levelScore"]?["totalScore"] ?? 0;
      }

      // 👉 Tambahkan score baru
      final int updatedLevelScore = oldLevelScore + newScore;
      final int updatedTotal = oldTotal + newScore;

      transaction.set(ref, {
        "levelScore": {
          level: updatedLevelScore,
          "totalScore": updatedTotal,
        }
      }, SetOptions(merge: true));
    });
  }
}
