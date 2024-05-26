import 'package:flutter/material.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/inner_screens/feed_screen.dart';
import 'package:mobile_app/providers/orders_provider.dart';
import 'package:mobile_app/screens/orders/order_widget.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/back_widget.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Color color = utils.color;

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;

    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? EmptyScreen(
                  title: 'Whoops!',
                  subtitle:
                      'You didnt place any order yet\nOrder & make our furry friends happy :)',
                  buttonText: 'Donate Now',
                  imagePath: 'assets/images/cart.jpeg',
                  primary: Colors.blue,
                  fct: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const FetchScreen(),
                    ));
                  },
                )
              : Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: const BackWidget(),
                    elevation: 0,
                    centerTitle: false,
                    title: TextWidget(
                      text: 'Your Orders (${ordersList.length})',
                      color: color,
                      textSize: 24,
                      isTitle: true,
                    ),
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  body: ListView.separated(
                    itemCount: ordersList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                          value: ordersList[index],
                          child: OrderWidget(),
                        ),
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
        });
  }
}
