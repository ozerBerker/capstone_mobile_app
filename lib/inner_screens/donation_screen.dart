import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({
    super.key,
    required this.donationStatus,
  });
  final bool donationStatus;

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  @override
  void initState() {
    if (widget.donationStatus) {
      sendDonationToFoodBowl();
    }
    super.initState();
  }

  Future<void> sendDonationToFoodBowl() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('foodBowls');

    String recordKey =
        '6f3db20d-cba9-4c09-aea5-ead3ffdd7625'; // Replace with your record key

    databaseReference.child(recordKey).update({
      'rmnFood': 4,
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
