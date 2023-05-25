import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Meal {
  String userID;
  String chosenCategory;
  String name;
  String imageUrl;
  String description;
  double timeInHours;
  double timeInMinutes;

  Meal(this.userID, this.chosenCategory, this.name, this.imageUrl, this.description, this.timeInHours, this.timeInMinutes);

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
      onError: (e) => Exception("Error completing: $e"),
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
      onError: (e) => Exception("Error completing: $e"),
    );
    return db.doc("trainers/$userID/meals/one day meal plan/One Day Meal Plan/$fullDayMealID");
  }
}

Future<List> getMealsFromFullDayMeal (String title, String userID) async {
  List meals = [];

  await db.collection("trainers/$userID/meals/one day meal plan/One Day Meal Plan").get().then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.get('name') == title) {
          var meal;
          if ((meal = docSnapshot.get('breakfast')) != "") meals.add(meal);
          if ((meal = docSnapshot.get('snack 1')) != "") meals.add(meal);
          if ((meal = docSnapshot.get('lunch')) != "") meals.add(meal);
          if ((meal = docSnapshot.get('snack 2')) != "") meals.add(meal);
          if ((meal = docSnapshot.get('dinner')) != "") meals.add(meal);
          break;
        }
      }
    },
    onError: (e) => Exception("Error completing: $e"),
  );
  return meals;
}

Future<List> getDayPlansFromOneWeekMeal (String title, String userID) async {
  List plans = [];

  await db.collection("trainers/$userID/meals/one week meal plan/One Week Meal Plan").get().then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.get('name') == title) {
          plans.add(docSnapshot.get('monday'));
          plans.add(docSnapshot.get('tuesday'));
          plans.add(docSnapshot.get('wednesday'));
          plans.add(docSnapshot.get('thursday'));
          plans.add(docSnapshot.get('friday'));
          plans.add(docSnapshot.get('saturday'));
          plans.add(docSnapshot.get('sunday'));
          break;
        }
      }
    },
    onError: (e) => Exception("Error completing: $e"),
  );
  return plans;
}

Future<List<String>> getMealPlans(userID) async {
  List<String> listMealPlans = [];

  await db.collection("trainers/$userID/meals/one week meal plan/One Week Meal Plan").get().then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        listMealPlans.add(docSnapshot.get('name'));
      }
    },
    onError: (e) => Exception("Error completing: $e"),
  );
  return listMealPlans;
}

Future<String> getOneWeekMealPlanPath(String selectedMealPlan, String trainerID) async{
  String oneWeekMealPlanID = "";

  if (selectedMealPlan == "None") {
    return "";
  } else {
    await db.collection("trainers/$trainerID/meals/one week meal plan/One Week Meal Plan").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.get('name') == selectedMealPlan) {
            oneWeekMealPlanID = docSnapshot.id;
            break;
          }
        }
      },
      onError: (e) => Exception("Error getting one week meal plan path: $e"),
    );
    return "trainers/$trainerID/meals/one week meal plan/One Week Meal Plan/$oneWeekMealPlanID";
  }
}

Future<String> getMealPlanName(mealPlanPath) async{
  String mealPlan = "None";

  if (mealPlanPath != '') {
    DocumentReference docRef = FirebaseFirestore.instance.doc(mealPlanPath);
    await docRef.get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        mealPlan = documentSnapshot['name'];
      }
    });
  }
  return mealPlan;
}