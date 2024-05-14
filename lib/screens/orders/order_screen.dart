import 'package:flutter/material.dart';
import 'package:mobile_app/screens/orders/order_widget.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/back_widget.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:mobile_app/widgets/text_widget.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Color color = utils.color;

    bool _isEmpty = true;

    if (_isEmpty == true) {
      return const EmptyScreen(
        title: 'Your did not place any order yet',
        subtitle: 'Order something and make me happy :)',
        buttonText: 'Shop now',
        imagePath: 'assets/images/cart.png',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const BackWidget(),
          elevation: 0,
          centerTitle: false,
          title: TextWidget(
            text: 'Your Orders (2)',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.separated(
          itemCount: 10,
          itemBuilder: (ctx, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: OrderWidget(),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: color,
              thickness: 1,
            );
          },
        ),
      );
    }
  }
}
