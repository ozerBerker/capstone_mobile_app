import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/foodBowl_model.dart';

class FoodBowlProvider with ChangeNotifier {
  static List<FoodBowlModel> _foodBowlsList = [];

  List<FoodBowlModel> get getFoodBowls {
    return _foodBowlsList;
  }

  Future<void> fetchFoodBowls() async {
    await FirebaseFirestore.instance
        .collection('foodBowls')
        .get()
        .then((QuerySnapshot foodBowlSnapshot) {
      _foodBowlsList.clear();
      foodBowlSnapshot.docs.forEach((element) {
        _foodBowlsList.insert(
            0,
            FoodBowlModel(
              id: element.get('id'),
              bowlLevel: element.get('bowlLevel'),
              containerSlot: element.get('containerSlot'),
              imageUrl: element.get('imageUrl'),
              location: element.get('location'),
              isActieve: element.get('isActieve'),
              price: element.get('price') + 1.1,
            ));
      });
    });
    notifyListeners();
  }

  List<FoodBowlModel> getFoodBowlsByLevel(String level) {
    return _foodBowlsList
        .where((element) => element.bowlLevel == level)
        .toList();
  }

  List<FoodBowlModel> getFoodContainerBySlot(int slot) {
    return _foodBowlsList
        .where((element) => element.containerSlot == slot)
        .toList();
  }

  FoodBowlModel findProductById(String foodBowlId) {
    return _foodBowlsList.firstWhere((element) => element.id == foodBowlId);
  }
}
