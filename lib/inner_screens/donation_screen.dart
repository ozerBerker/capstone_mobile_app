import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({
    super.key,
    required this.donationStatus,
    required this.id,
    required this.rmnFood,
  });
  final bool donationStatus;
  final String id;
  final int rmnFood;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int donatedSlot = -1;

  @override
  void initState() {
    getDonatedSlot();
    super.initState();
    if (widget.donationStatus) {
      sendDonationToFoodBowl();
    }
  }

  Future<void> getDonatedSlot() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('foodBowls')
        .child("6f3db20d-cba9-4c09-aea5-ead3ffdd7625");

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        final values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        setState(() {
          donatedSlot = values['rmnFood'];
        });
      }
    });
  }

  Future<void> sendDonationToFoodBowl() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('foodBowls').child(widget.id);

    databaseReference.update({
      'rmnFood': donatedSlot + widget.rmnFood,
    });

    await Fluttertoast.showToast(
      msg: "Your order has been placed",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 1,
      // backgroundColor: Colors.grey.shade600,
      // textColor: Colors.white,
      // fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.donationStatus
        ? EmptyScreen(
            title: 'Success!',
            subtitle: 'Donation made successfully!',
            buttonText: 'Home Page',
            imagePath: 'assets/images/success.png',
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
            imagePath: 'assets/images/failed.png',
            primary: Colors.red,
            fct: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const FetchScreen(),
              ));
            },
          );
  }
}
