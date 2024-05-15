import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/inner_screens/foodBowl_details_screen.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/models/products_model.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/providers/wishlist_provider.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/button_widget.dart';
import 'package:mobile_app/widgets/hearth_btn.dart';
import 'package:mobile_app/widgets/price_widget.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final foodBowlModel = Provider.of<FoodBowlModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isCInCart = cartProvider.getCartItems.containsKey(foodBowlModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(foodBowlModel.id);

    return Padding(
        padding: const EdgeInsets.only(left: 25.0, bottom: 15),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
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
                  color: color,
                  textSize: 22,
                  isTitle: true,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Bowl: ',
                      color: color,
                      textSize: 14,
                      isTitle: true,
                    ),
                    TextWidget(
                        text: foodBowlModel.bowlLevel,
                        color: color,
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
                      color: color,
                      textSize: 14,
                      isTitle: true,
                    ),
                    TextWidget(
                        text: foodBowlModel.containerSlot.toString(),
                        color: color,
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
                      backgroundColor: Colors.teal,
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
