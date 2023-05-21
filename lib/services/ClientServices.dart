import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_gym_planner/services/workout/OneWeekWorkoutServices.dart';
import 'MealServices.dart';

class Client {
  String trainerID;
  String customerID;
  String workoutPlan;
  String mealPlan;

  Client(this.trainerID, this.customerID, this.workoutPlan, this.mealPlan);

  Future<void> addClient() async {
    final firestore = FirebaseFirestore.instance;

    try {
      if( trainerID == "" || customerID == "" || workoutPlan == "" || mealPlan == "") {
        throw Exception('Field cannot be empty.');
      }

      await firestore.collection("customers")
          .doc(customerID)
          .update({'trainer': trainerID,
                   'workoutPlan': await getOneWeekWorkoutPlanReference(workoutPlan, trainerID),
                   'mealPlan': await getOneWeekMealPlanReference(mealPlan, trainerID)
          });
    } catch (e) {
      throw Exception('Client plans cannot be added to firebase.');
    }
  }
}
