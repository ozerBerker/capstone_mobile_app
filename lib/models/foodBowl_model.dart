import 'package:flutter/material.dart';

class FoodBowlModel with ChangeNotifier {
  final String id, bowlLevel, imageUrl, location;
  final double price;
  final int containerSlot;
  final bool isActieve;

  FoodBowlModel({
    required this.id,
    required this.bowlLevel,
    required this.containerSlot,
    required this.imageUrl,
    required this.location,
    required this.isActieve,
    required this.price,
  });
}
