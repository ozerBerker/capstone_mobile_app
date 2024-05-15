import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:mobile_app/screens/wallet/shopping_cart_widget.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            // badges.Badge(
            //   badgeContent: FittedBox(
            //       child: TextWidget(
            //           text: '100 tl', color: Colors.white, textSize: 15)),
            //   position: badges.BadgePosition.topEnd(
            //       top: size.width * 0.1, end: size.width * 0.1),
            //   badgeStyle: badges.BadgeStyle(
            //     shape: badges.BadgeShape.square,
            //     badgeColor: Colors.blue,
            //     borderRadius: BorderRadius.circular(8),
            //     borderSide: BorderSide(color: Colors.white, width: 2),
            //     elevation: 0,
            //   ),
            //   child: Image.asset(
            //     'assets/images/cart.png',
            //     width: double.infinity,
            //     height: size.height * 0.4,
            //   ),
            // ),
            Image.asset(
              'assets/images/wallet.png',
              width: double.infinity,
              height: size.height * 0.3,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: 'Balance',
              color: color,
              textSize: 20,
              isTitle: true,
            ),
            TextWidget(text: '100 tl', color: color, textSize: 24),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide.none),
                  backgroundColor: Color(0xff55AF87),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {},
                child: TextWidget(
                  text: 'Load Money',
                  color: Colors.white,
                  textSize: 20,
                  isTitle: true,
                ))
          ],
        ),
      )),
    );
  }
}
