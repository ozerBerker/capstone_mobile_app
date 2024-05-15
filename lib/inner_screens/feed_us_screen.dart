import 'package:flutter/material.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/models/products_model.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/providers/products_provider.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/back_widget.dart';
import 'package:mobile_app/widgets/empty_products_widget.dart';
import 'package:mobile_app/widgets/feed_us_widget.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class FeedUsScreen extends StatelessWidget {
  static const routeName = "/FeedUsScreen";
  const FeedUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool _isEmpty = true;
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final foodBowlProvider = Provider.of<FoodBowlProvider>(context);
    List<FoodBowlModel> onSaleProducts = foodBowlProvider.getFoodBowls;

    return Scaffold(
      appBar: AppBar(
        leading: BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: onSaleProducts.isEmpty
          ? const EmptyProductWidget(
              text: 'No product on sale yet!\nStay tuned',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.75),
              children: List.generate(onSaleProducts.length, (index) {
                return ChangeNotifierProvider.value(
                  value: onSaleProducts[index],
                  child: const FeedUsWidget(),
                );
              }),
            ),
    );
  }
}
