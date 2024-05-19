import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrdersModel> _orders = [];

  List<OrdersModel> get getOrderss {
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
