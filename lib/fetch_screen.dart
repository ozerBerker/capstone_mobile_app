import 'package:flutter/material.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/screens/bottom_bar.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  void initState() {
    Future.delayed(Duration(microseconds: 5), () async {
      final foodBowlProvider =
          Provider.of<FoodBowlProvider>(context, listen: false);
      await foodBowlProvider.fetchFoodBowls();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBarScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
