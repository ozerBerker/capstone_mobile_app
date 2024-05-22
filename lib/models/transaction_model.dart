import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionModel with ChangeNotifier {
  final String transactionId;
  final String? orderId;
  final double oldAmount, processAmount;

  final Timestamp processDate;
  final bool isItInflow;

  TransactionModel({
    this.orderId,
    required this.transactionId,
    required this.oldAmount,
    required this.processAmount,
    required this.processDate,
    required this.isItInflow,
  });
}
