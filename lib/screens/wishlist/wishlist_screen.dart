import 'package:flutter/material.dart';
import 'package:mobile_app/providers/wishlist_provider.dart';
import 'package:mobile_app/screens/wishlist/wishlist_widget.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/back_widget.dart';
import 'package:mobile_app/widgets/empty_screen.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Color color = utils.color;

    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your wishlist is empty',
            subtitle: 'Explore more and shortlist some items',
            buttonText: 'Add a wish',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: const BackWidget(),
              elevation: 0,
              backgroundColor: Theme.of(context).cardColor,
              title: TextWidget(
                text: 'Wishlists (${wishlistItemList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods().warningDialog(
                          title: 'Empty your cart?',
                          subtitle: 'Are you sıre?',
                          fct: () {
                            wishlistProvider.clearWishlist();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: MasonryGridView.count(
              itemCount: wishlistItemList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 16,
              // crossAxisSpacing: 20,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItemList[index],
                    child: const WishlistWidget());
              },
            ),
          );
  }
}
