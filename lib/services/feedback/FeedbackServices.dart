import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class myFeedback {
  final bool workoutHardness;
  final bool painDuringPlan;
  final bool challengedByPlan;
  final bool changePlan;
  final String additionalFeedback;

  myFeedback(this.workoutHardness, this.painDuringPlan, this.challengedByPlan, this.changePlan, this.additionalFeedback);

  Future<void> addFeedback() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection("customers")
          .doc(userID)
          .collection("feedback")
          .doc("feedbackAnswers")
          .set({'challenged': challengedByPlan ? 'Yes' : 'No',
                  'change': changePlan ? 'Yes' : 'No',
                  'comments': additionalFeedback,
                  'hardness': workoutHardness ? 'Yes' : 'No',
                  'hurt': painDuringPlan ? 'Yes' : 'No'
      },
          SetOptions(merge: true) // Use merge: true to update existing fields and add new ones
      );
  }
}
