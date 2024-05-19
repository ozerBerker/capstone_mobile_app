import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersModel with ChangeNotifier {
  final String orderId, userId, foodBowlId, userName, userEmail, imageUrl;
  final double price;
  final int containerSlot;
  final Timestamp orderDate;

  OrdersModel({
    required this.orderId,
    required this.userId,
    required this.foodBowlId,
    required this.userName,
    required this.userEmail,
    required this.price,
    required this.containerSlot,
    required this.imageUrl,
    required this.orderDate,
  });
}
