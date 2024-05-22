import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/models/orders_model.dart';
import 'package:uuid/uuid.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrdersModel> _orders = [];

  List<OrdersModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((QuerySnapshot _ordersSnapshot) {
      _orders.clear();
      _ordersSnapshot.docs.forEach((element) {
        _orders.insert(
            0,
            OrdersModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              foodBowlId: element.get('foodBowlId'),
              userName: element.get('userName'),
              userEmail: element.get('userEmail'),
              price: element.get('price'),
              containerSlot: element.get('containerSlot'),
              imageUrl: element.get('imageUrl'),
              orderDate: element.get('orderDate'),
            ));
      });
    });
    notifyListeners();
  }
}
