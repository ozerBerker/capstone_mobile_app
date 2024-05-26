import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/inner_screens/foodBowl_details_screen.dart';
import 'package:mobile_app/models/orders_model.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/providers/orders_provider.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrdersModel>(context);

    final foodBowlProvider = Provider.of<FoodBowlProvider>(context);
    final getCurrFoodBowl =
        foodBowlProvider.findFoodBowlById(ordersModel.foodBowlId);

    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    Color color = utils.color;

    return ListTile(
      subtitle: Text('Paid: ₺${ordersModel.price.toStringAsFixed(2)}'),
      onTap: () {
        GlobalMethods.navigateTo(
            ctx: context, routeName: FoodBowlDetail.routeName);
      },
      leading: Image.asset(
        'assets/images/bowl.png',
        width: size.width * 0.2,
      ),
      // FancyShimmerImage(
      //   width: size.width * 0.2,
      //   imageUrl: 'assets/images/bowl.png',
      //   boxFit: BoxFit.fill,
      // ),
      title: TextWidget(
          text: getCurrFoodBowl.location, color: color, textSize: 18),
      trailing: TextWidget(
          text: GlobalMethods.orderDateToShow(ordersModel.orderDate),
          color: color,
          textSize: 18),
    );
  }
}
