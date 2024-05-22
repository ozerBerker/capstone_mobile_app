import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/providers/transaction_provider.dart';
import 'package:mobile_app/screens/auth/login.dart';
import 'package:mobile_app/screens/loading_manager.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/transaction_widget.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _walletTextController =
      TextEditingController(text: "");

  @override
  void dispose() {
    _walletTextController.dispose();
    super.dispose();
  }

  double? _userWallet;
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  bool _isLoading = false;
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _userWallet = userDoc.get('userWallet').toDouble();
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    Color color = utils.color;

    final transactionProvider = Provider.of<TransactionProvider>(context);

    return FutureBuilder(
        future: transactionProvider.fetchTransactions(),
        builder: (context, snapshot) {
          return LoadingManager(
            isLoading: _isLoading,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
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
                          height: size.height * 0.2,
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
                        TextWidget(
                            text: '${_userWallet ?? 'No User'}',
                            color: color,
                            textSize: 24),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide.none),
                              backgroundColor: const Color(0xff55AF87),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                            ),
                            onPressed: () {
                              if (user == null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                                return;
                              }
                              loadMoneyToWallet(wallet: _userWallet ?? 0);
                              makeTransaction();
                            },
                            child: TextWidget(
                              text: 'Load Money',
                              color: Colors.white,
                              textSize: 20,
                              isTitle: true,
                            ))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: const [
                                TransactionWidget(),
                                Divider(
                                  thickness: 3,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> loadMoneyToWallet({
    required double wallet,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextWidget(
              text: "Load Money to balance",
              textSize: 18,
              color: Colors.black.withOpacity(0.7),
            ),
            content: TextField(
              controller: _walletTextController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[0-9]'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // final total =
                  //     wallet + double.parse(_walletTextController.text);
                  final total = double.parse(_walletTextController.text);
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'userWallet': total,
                    });
                    Navigator.pop(context);
                    setState(() {
                      _userWallet = total;
                    });
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        subtitle: err.toString(), context: context);
                  }
                },
                child: const Text("Complete"),
              )
            ],
          );
        });
  }

  Future<void> makeTransaction() async {
    final transactionId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance
          .collection('transaction')
          .doc(transactionId)
          .set({
        'id': transactionId,
        'orderId': "",
        'oldAmount': _userWallet,
        'processAmount': double.parse(_walletTextController.text),
        'processDate': Timestamp.now(),
        'isItInflow': true,
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    }
  }
}
