import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/workout/OneWeekWorkoutServices.dart';
import 'meal/MealServices.dart';
import 'auth_methods.dart';

class Client {
  String trainerID;
  String customerID;
  String workoutPlan;
  String mealPlan;
  bool feedback;

  Client(this.trainerID, this.customerID, this.workoutPlan, this.mealPlan, this.feedback);

  Future<void> addClient() async {
    try {
      if( trainerID == "" || customerID == "" || workoutPlan == "" || mealPlan == "") {
        throw Exception('Field cannot be empty.');
      }

      await FirebaseFirestore.instance.collection("customers")
          .doc(customerID)
          .update({'trainer': trainerID,
                   'workoutPlan': await getOneWeekWorkoutPlanPath(workoutPlan, trainerID),
                   'mealPlan': await getOneWeekMealPlanPath(mealPlan, trainerID)
          });
    } catch (e) {
      throw Exception('Client plans cannot be added to firebase.');
    }
  }

  Future<void> editClient() async {
    try {
      if( trainerID == "" || customerID == "" || workoutPlan == "" || mealPlan == "") {
        throw Exception('Field cannot be empty.');
      }

      await FirebaseFirestore.instance.collection("customers")
          .doc(customerID)
          .update({
            'workoutPlan': await getOneWeekWorkoutPlanPath(workoutPlan, trainerID),
            'mealPlan': await getOneWeekMealPlanPath(mealPlan, trainerID)
          });
    } catch (e) {
      throw Exception('Client plans cannot be edited.');
    }
  }
}

Future<String> getWorkoutFeedback(String question, String clientID) async {
  try {
    final feedbackSnapshot = await db
        .collection("customers")
        .doc(clientID)
        .collection("feedback")
        .doc("feedbackAnswers")
        .get();

    if (feedbackSnapshot.exists) {
      Map<String, dynamic>? feedbackData = feedbackSnapshot.data();
      if (feedbackData != null && feedbackData.containsKey(question)) {
        return feedbackData[question].toString();
      } else {
        return 'Question not found in feedback data';
      }
    } else {
      return 'Workout feedback not available';
    }
  } catch (e) {
    throw Exception('Error getting the feedback');
  }
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getClients() async{
  List<QueryDocumentSnapshot<Map<String, dynamic>>> listClients = [];
  FirebaseAuthMethods authService = FirebaseAuthMethods();
  String trainerID = await authService.getUserId();

  await db.collection("customers").get().then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.get('trainer') == trainerID) {
          listClients.add(docSnapshot);
        }
      }
    },
    onError: (e) => Exception("Error getting clients: $e"),
  );

  return listClients;
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFeedbackClients() async {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> listClients = [];
  FirebaseAuthMethods authService = FirebaseAuthMethods();
  String trainerID = await authService.getUserId();

  await db.collection("customers").get().then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.get('trainer') == trainerID && docSnapshot.get('feedback') == true) {
          listClients.add(docSnapshot);
        }
      }
    },
    onError: (e) => throw Exception("Error getting clients: $e"),
  );

  return listClients;
}

Future<bool> trainerHasThisClient(String email, String trainerID) async{
  final customers = FirebaseFirestore.instance.collection('customers');
  final userSnapshot = await customers.where('email', isEqualTo: email).get();
  if (userSnapshot.docs[0]['trainer'] == trainerID) {
    return true;
  } else {
    return false;
  }
}