import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String userID;
  String chosenCategory;
  String name;
  String imageUrl;
  String description;
  double timeInHours;
  double timeInMinutes;

  Meal(this.userID, this.chosenCategory, this.name, this.imageUrl, this.description, this.timeInHours, this.timeInMinutes);
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addMealToFirestore() async {
    String mealsCategory = "meal";

    try {
      if( chosenCategory == "" || name == "" || imageUrl == "" || description == "") {
        throw Exception('Field cannot be empty.');
      }

      final meals = db.collection("trainers").doc(userID).collection("meals");
      meals.doc(mealsCategory).set({});

      await db.collection("trainers")
          .doc(userID)
          .collection("meals")
          .doc(mealsCategory)
          .collection(chosenCategory)
          .add({'name': name,
                'imageUrl': imageUrl,
                'description': description,
                'timeInHours': timeInHours,
                'timeInMinutes': timeInMinutes});
    } catch (e) {
      throw Exception('Meal cannot be added to firebase.');
    }
  }
}

class FullDayMeal {
  String userID;
  String name;
  String breakfast;
  String snack1;
  String lunch;
  String snack2;
  String dinner;

  FullDayMeal(this.userID, this.name, this.breakfast, this.snack1, this.lunch, this.snack2, this.dinner);

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addFullMealToFirestore() async {
    String mealsCategory = "one day meal plan";

    try {
      if( name == "" || breakfast == "" || lunch == "" || dinner == "") {
        throw Exception('Field cannot be empty.');
      }

      final meals = db.collection("trainers").doc(userID).collection("meals");
      meals.doc(mealsCategory).set({});

      await db.collection("trainers")
          .doc(userID)
          .collection("meals")
          .doc(mealsCategory)
          .collection("One Day Meal Plan")
          .add({'name': name,
                'breakfast': await getMealReference(breakfast, "Breakfast"),
                'snack 1': await getMealReference(snack1, "Snack"),
                'lunch': await getMealReference(lunch, "Lunch"),
                'snack 2': await getMealReference(snack2, "Snack"),
                'dinner': await getMealReference(dinner, "Dinner")});

    } catch (e) {
      throw Exception('Full Day Meal cannot be added to firebase: $e');
    }
  }

  Future<Object> getMealReference(String selectedMeal, String category)  async{
    String mealID = "";
    await db.collection("trainers/$userID/meals/meal/$category").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.get('name') == selectedMeal) {
            mealID = docSnapshot.id;
            break;
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    if (mealID != "") {
      return db.doc("trainers/$userID/meals/meal/$category/$mealID");
    } else {
      return "";
    }
  }
}

class OneWeekMealPlan {
  String userID;
  String weekPlanName;
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String sunday;

  OneWeekMealPlan(this.userID, this.weekPlanName, this.monday, this.tuesday, this.wednesday, this.thursday, this.friday, this.saturday, this.sunday);

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addOneWeekPlanToFirestore() async {
    String mealsCategory = "one week meal plan";

    try {
      if(weekPlanName == "" || monday == "" || tuesday == "" || wednesday == "" || thursday == "" || friday == "" || saturday == "" || sunday == "") {
        throw Exception('Field cannot be empty.');
      }

      final meals = db.collection("trainers").doc(userID).collection("meals");
      meals.doc(mealsCategory).set({});

      await db.collection("trainers")
          .doc(userID)
          .collection("meals")
          .doc(mealsCategory)
          .collection("One Week Meal Plan")
          .add({'name': weekPlanName,
                'monday':await getFullDayMealReference(monday),
                'tuesday': await getFullDayMealReference(tuesday),
                'wednesday': await getFullDayMealReference(wednesday),
                'thursday': await getFullDayMealReference(thursday),
                'friday': await getFullDayMealReference(friday),
                'saturday': await getFullDayMealReference(saturday),
                'sunday': await getFullDayMealReference(sunday)});

    } catch (e) {
      throw Exception('One Week Meal Plan cannot be added to firebase: $e');
    }
  }

  Future<Object> getFullDayMealReference(String selectedMealPlan)  async{
    String fullDayMealID = "";
    await db.collection("trainers/$userID/meals/one day meal plan/One Day Meal Plan").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.get('name') == selectedMealPlan) {
            fullDayMealID = docSnapshot.id;
            break;
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return db.doc("trainers/$userID/meals/one week meal plan/One Week Meal Plan/$fullDayMealID");
  }
}