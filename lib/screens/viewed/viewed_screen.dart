import 'package:flutter/material.dart';
import 'package:mobile_app/providers/viewed_provider.dart';
import 'package:mobile_app/screens/orders/order_widget.dart';
import 'package:mobile_app/screens/viewed/viewed_widget.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/back_widget.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ViewedScreen extends StatelessWidget {
  static const routeName = '/ViewedScreen';
  const ViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Color color = utils.color;

    bool _isEmpty = true;

    final viewedProvider = Provider.of<ViewedProductProvider>(context);
    final viewedItemList =
        viewedProvider.getViewedProdlistItems.values.toList().reversed.toList();
    return viewedItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your history is empty',
            subtitle: 'No products has been viewed yet!',
            buttonText: 'Shop now',
            imagePath: 'assets/images/history.png',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: const BackWidget(),
              elevation: 0,
              centerTitle: true,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              title: TextWidget(
                text: 'History',
                color: color,
                textSize: 24,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods().warningDialog(
                          title: 'Empty your cart?',
                          subtitle: 'Are you sıre?',
                          fct: () {},
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: ListView.builder(
                itemCount: viewedItemList.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: ChangeNotifierProvider.value(
                        value: viewedItemList[index], child: ViewedWidget()),
                  );
                })));
  }
}
