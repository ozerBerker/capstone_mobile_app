import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/inner_screens/foodBowl_details_screen.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class FeedUsWidget extends StatefulWidget {
  const FeedUsWidget({super.key});

  @override
  State<FeedUsWidget> createState() => _FeedUsWidgetState();
}

class _FeedUsWidgetState extends State<FeedUsWidget> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final foodBowlModel = Provider.of<FoodBowlModel>(context);

    return Padding(
        padding: const EdgeInsets.only(left: 25.0, bottom: 15),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          // color: Colors.grey.shade200,
          color: Color(0xff1C4189),
          child: InkWell(
            onTap: () {
              // GlobalMethods()
              //     .navigateTo(ctx: context, routeName: ProductDetails.routeName);
              Navigator.pushNamed(context, FoodBowlDetail.routeName,
                  arguments: foodBowlModel.id);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FancyShimmerImage(
                  imageUrl: foodBowlModel.imageUrl,
                  height: size.width * 0.2,
                  width: size.width * 0.2,
                  boxFit: BoxFit.fill,
                ),
                TextWidget(
                  text: foodBowlModel.location,
                  color: Colors.white,
                  textSize: 22,
                  isTitle: true,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Bowl: ',
                      color: Colors.white,
                      textSize: 14,
                      isTitle: true,
                    ),
                    TextWidget(
                        text: foodBowlModel.bowlLevel,
                        color: Colors.white,
                        textSize: 14),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Container: ',
                      color: Colors.white,
                      textSize: 14,
                      isTitle: true,
                    ),
                    TextWidget(
                        text: foodBowlModel.containerSlot.toString(),
                        color: Colors.white,
                        textSize: 14),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FoodBowlDetail.routeName,
                          arguments: foodBowlModel.id);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.3, size.height * 0.05),
                      backgroundColor: Color(0xffFF914D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: TextWidget(
                      text: 'Donate',
                      color: Colors.white,
                      textSize: 20,
                      isTitle: true,
                    )),
              ],
            ),
          ),
        ));
  }
}
