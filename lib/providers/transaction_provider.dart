import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  static List<TransactionModel> _transactions = [];

  List<TransactionModel> get getTransactions {
    return _transactions;
  }

  Future<void> fetchTransactions() async {
    await FirebaseFirestore.instance
        .collection('transaction')
        .get()
        .then((QuerySnapshot transactionsSnapshot) {
      _transactions.clear();
      transactionsSnapshot.docs.forEach((element) {
        _transactions.insert(
            0,
            TransactionModel(
              orderId: element.get('orderId'),
              transactionId: element.get('transactionId'),
              oldAmount: element.get('oldAmount'),
              processAmount: element.get('processAmount'),
              processDate: element.get('processDate'),
              isItInflow: element.get('isItInflow'),
            ));
      });
    });
    notifyListeners();
  }
}
