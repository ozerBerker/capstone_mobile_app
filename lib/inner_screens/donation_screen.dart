import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/screens/bottom_bar.dart';
import 'package:mobile_app/screens/home.screen.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({
    super.key,
    required this.donationStatus,
    required this.foodBowl,
  });
  final bool donationStatus;
  final FoodBowlModel foodBowl;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  Future<void> addOrders() async {
    User? user = authInstance.currentUser;
    final currFoodBowl = widget.foodBowl;
    final orderId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'userId': user!.uid,
        'foodBowlId': currFoodBowl.id,
        'userName': user.displayName,
        'userEmail': user.email,
        'price': currFoodBowl.price,
        'containerSlot': currFoodBowl.containerSlot,
        'imageUrl': currFoodBowl.imageUrl,
        'orderDate': Timestamp.now(),
      });
      Fluttertoast.showToast(
        msg: "Your order has been placed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        // timeInSecForIosWeb: 1,
        // backgroundColor: Colors.grey.shade600,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );
    } catch (err) {
      GlobalMethods.errorDialog(subtitle: err.toString(), context: context);
    } finally {}
  }

  @override
  void initState() {
    if (widget.donationStatus) {
      addOrders();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.donationStatus
        ? EmptyScreen(
            title: 'Success!',
            subtitle: 'Donation made successfully! ',
            buttonText: 'Home Page',
            imagePath: 'assets/images/cart.png',
            primary: Colors.green,
            fct: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const FetchScreen(),
              ));
            },
          )
        : EmptyScreen(
            title: 'Opps!',
            subtitle:
                'Something went wrong, but it`s\n nothing to worry about!',
            buttonText: 'Load Money',
            imagePath: 'assets/images/cart.png',
            primary: Colors.red,
            fct: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const FetchScreen(),
              ));
            },
          );
  }
}
