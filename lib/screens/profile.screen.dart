import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/providers/dark_theme_provider.dart';
import 'package:mobile_app/screens/auth/forgot_passwprd.dart';
import 'package:mobile_app/screens/auth/login.dart';
import 'package:mobile_app/screens/loading_manager.dart';
import 'package:mobile_app/screens/orders/order_screen.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _biographyTextController =
      TextEditingController(text: "");

  @override
  void dispose() {
    _biographyTextController.dispose();
    super.dispose();
  }

  String? _email, _name, _bio;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

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
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        _bio = userDoc.get('bio');
        _biographyTextController.text = userDoc.get('bio');
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
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final size = Utils(context).getScreenSize;
    return Scaffold(
        body: LoadingManager(
      isLoading: _isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/box.png',
                      height: size.width * 0.2,
                    ),
                  ),
                ],
              ),
              RichText(
                  text: TextSpan(
                      text: 'Hi,   ',
                      style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                    TextSpan(
                        text: _name ?? 'user',
                        style: TextStyle(
                            color: color,
                            fontSize: 27,
                            fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("My name is Berker");
                          })
                  ])),
              const SizedBox(
                height: 5,
              ),
              TextWidget(text: _email ?? 'email', color: color, textSize: 18),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              _listTiles(
                title: 'Biography',
                subtitle: 'To view click here',
                icon: IconlyLight.profile,
                onPressed: () async {
                  await _showAddressDialog();
                },
                color: color,
              ),
              _listTiles(
                title: 'Orders',
                icon: IconlyLight.bag,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: OrderScreen.routeName);
                },
                color: color,
              ),
              _listTiles(
                title: 'Forgot Password',
                icon: IconlyLight.unlock,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ));
                },
                color: color,
              ),
              SwitchListTile(
                title: Text(
                  themeState.getDarkTheme ? "Dark Mode" : "Light Mode",
                  style: TextStyle(
                      color: color, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  setState(() {
                    themeState.setDarkTheme = value;
                  });
                },
                value: themeState.getDarkTheme,
              ),
              SizedBox(
                height: 10,
              ),
              _listTiles(
                title: user == null ? 'Login' : 'Logout',
                icon: user == null ? IconlyLight.login : IconlyLight.logout,
                onPressed: () {
                  if (user == null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                    return;
                  }
                  GlobalMethods.warningDialog(
                      title: 'Sign out',
                      subtitle: 'Do you wanna sign out?',
                      fct: () async {
                        await authInstance.signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      context: context);
                },
                color: color,
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit if you want"),
            content: TextField(
              // onChanged: (value) {
              //   print(
              //       '_biographyTextController.text ${_biographyTextController.text}');
              // },
              controller: _biographyTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your Address"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'bio': _biographyTextController.text,
                    });
                    Navigator.pop(context);
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        subtitle: err.toString(), context: context);
                  }
                },
                child: const Text("Update"),
              )
            ],
          );
        });
  }

  Widget _listTiles(
      {required String title,
      String? subtitle,
      required IconData icon,
      required Function onPressed,
      required Color color}) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
        isTitle: true,
      ),
      subtitle: TextWidget(text: subtitle ?? "", color: color, textSize: 14),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
