import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/inner_screens/foodBowl_details_screen.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/price_widget.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({super.key});

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final foodBowlModel = Provider.of<FoodBowlModel>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff1C4189).withOpacity(0.8),
        child: InkWell(
          onTap: () {
            if (foodBowlModel.isActieve) {
              Navigator.pushNamed(context, FoodBowlDetail.routeName,
                  arguments: foodBowlModel.id);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/cart-icon.png',
                    height: size.width * 0.25,
                    width: size.width * 0.25,
                  ),
                  // FancyShimmerImage(
                  //   imageUrl: foodBowlModel.imageUrl,
                  //   height: size.width * 0.2,
                  //   width: size.width * 0.2,
                  //   boxFit: BoxFit.fill,
                  // ),
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
                        if (foodBowlModel.isActieve) {
                          Navigator.pushNamed(context, FoodBowlDetail.routeName,
                              arguments: foodBowlModel.id);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.3, size.height * 0.05),
                        backgroundColor: Color(0xffFF914D).withOpacity(0.9),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 50),
                  //   child: Flexible(
                  //       flex: 2,
                  //       child: TextFormField(
                  //         controller: _quantityTextController,
                  //         key: const ValueKey('10'),
                  //         style: TextStyle(color: color, fontSize: 16),
                  //         keyboardType: TextInputType.number,
                  //         maxLines: 1,
                  //         textAlign: TextAlign.center,
                  //         enabled: true,
                  //         onChanged: (value) {},
                  //         inputFormatters: [
                  //           FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                  //         ],
                  //       )),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  // ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       minimumSize: Size(size.width * 0.3, size.height * 0.05),
                  //       backgroundColor: Colors.teal,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     child: TextWidget(
                  //       text: 'Donate',
                  //       color: Colors.white,
                  //       textSize: 20,
                  //       isTitle: true,
                  //     )),
                ],
              ),
              if (!foodBowlModel.isActieve)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
