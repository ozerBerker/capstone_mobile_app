import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/inner_screens/donation_screen.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/providers/orders_provider.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FoodBowlDetail extends StatefulWidget {
  static const routeName = '/FoodBowlDetail';

  const FoodBowlDetail({super.key});

  @override
  State<FoodBowlDetail> createState() => _FoodBowlDetailState();
}

class _FoodBowlDetailState extends State<FoodBowlDetail> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  late double totalPrice;
  double? _userWallet;
  final User? user = authInstance.currentUser;
  Future<void> getUserData() async {
    if (user == null) {
      return;
    }
    try {
      setState(() async {
        String _uid = user!.uid;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .get();
        if (userDoc == null) {
          return;
        } else {
          _userWallet = userDoc.get('userWallet').toDouble();
        }
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final foodBowlProvider = Provider.of<FoodBowlProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final foodBowlId = ModalRoute.of(context)!.settings.arguments as String;

    final getCurrFoodBowl = foodBowlProvider.findFoodBowlById(foodBowlId);

    totalPrice =
        getCurrFoodBowl.price * int.parse(_quantityTextController.text);

    return PopScope(
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: Image.asset(
                'assets/images/detail-icon.jpeg',
              ),
              // FancyShimmerImage(
              //   // imageUrl: getCurrFoodBowl.imageUrl,
              //   imageUrl: 'assets/images/detail-icon.png',
              //   boxFit: BoxFit.fill,
              //   width: size.width,
              // ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextWidget(
                                text: getCurrFoodBowl.location,
                                color: color,
                                textSize: 25,
                                isTitle: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text:
                                  '\₺${getCurrFoodBowl.price.toStringAsFixed(2)}',
                              color: color,
                              textSize: 22,
                              isTitle: true,
                            ),
                            TextWidget(
                              text: ' per slot',
                              color: color,
                              textSize: 12,
                              isTitle: false,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xff1C4189),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  TextWidget(
                                    text: getCurrFoodBowl.bowlLevel,
                                    color: Colors.white,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.pets,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quantityControl(
                              fct: () {
                                if (_quantityTextController.text == '1') {
                                  return;
                                } else {
                                  setState(() {
                                    _quantityTextController.text = (int.parse(
                                                _quantityTextController.text) -
                                            1)
                                        .toString();
                                  });
                                }
                              },
                              icon: CupertinoIcons.minus,
                              color: Colors.red),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              child: TextField(
                            controller: _quantityTextController,
                            key: const ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {
                                  return;
                                }
                              });
                            },
                          )),
                          SizedBox(
                            width: 5,
                          ),
                          quantityControl(
                              fct: () {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) +
                                              1)
                                          .toString();
                                });
                              },
                              icon: CupertinoIcons.plus,
                              color: Colors.green),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Total',
                                  color: Color(0xff1C4189),
                                  textSize: 20,
                                  isTitle: true,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '₺${totalPrice.toStringAsFixed(2)} | ',
                                        color: color,
                                        textSize: 20,
                                        isTitle: true,
                                      ),
                                      TextWidget(
                                        text:
                                            '${_quantityTextController.text} ~ Slot',
                                        color: color,
                                        textSize: 16,
                                        isTitle: false,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: Material(
                              color: Color(0xff1C4189),
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () async {
                                  var donationStatus = false;
                                  if (_userWallet! >= totalPrice) {
                                    donationStatus = true;
                                    await updateWallet();
                                    String orderId = await addOrders(
                                        getCurrFoodBowl: getCurrFoodBowl);
                                    await makeTransaction(orderId: orderId);
                                  }

                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => DonationScreen(
                                      donationStatus: donationStatus,
                                      id: getCurrFoodBowl.id,
                                      rmnFood: int.parse(
                                          _quantityTextController.text),
                                    ),
                                  ));
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: TextWidget(
                                    text: 'Donate',
                                    color: Colors.white,
                                    textSize: 18,
                                    isTitle: true,
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  quantityControl(
      {required Null Function() fct,
      required IconData icon,
      required MaterialColor color}) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateWallet() async {
    String _uid = user!.uid;
    double wallet = _userWallet! - totalPrice;
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWallet': wallet,
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    }
  }

  Future<void> makeTransaction({required String orderId}) async {
    final transactionId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance
          .collection('transaction')
          .doc(transactionId)
          .set({
        'transactionId': transactionId,
        'orderId': orderId,
        'oldAmount': _userWallet,
        'processAmount': totalPrice,
        'processDate': Timestamp.now(),
        'isItInflow': false,
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    }
  }

  Future<String> addOrders({required FoodBowlModel getCurrFoodBowl}) async {
    User? user = authInstance.currentUser;
    final currFoodBowl = getCurrFoodBowl;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    final orderId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'userId': user!.uid,
        'foodBowlId': currFoodBowl.id,
        'userName': user.displayName,
        'userEmail': user.email,
        'price': totalPrice,
        'containerSlot': currFoodBowl.containerSlot,
        'imageUrl': currFoodBowl.imageUrl,
        'orderDate': Timestamp.now(),
      });
      await ordersProvider.fetchOrders();
    } catch (err) {
      GlobalMethods.errorDialog(subtitle: err.toString(), context: context);
    } finally {
      return orderId;
    }
  }
}
