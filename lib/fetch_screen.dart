import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/consts/consts.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/screens/bottom_bar.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Consts.loadingImages;
  @override
  void initState() {
    images.shuffle();
    Future.delayed(Duration(microseconds: 5), () async {
      // final User? user = authInstance.currentUser;
      // String _uid = user!.uid;
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.fetchUser(_uid);

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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
