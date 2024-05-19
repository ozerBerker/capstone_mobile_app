import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/inner_screens/feed_screen.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/widgets/button_widget.dart';
import 'package:mobile_app/widgets/text_widget.dart';

import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText,
      required this.primary,
      required this.fct})
      : super(key: key);

  final String imagePath, title, subtitle, buttonText;
  final Color primary;
  final Function fct;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final themeState = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
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
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.09,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(112.0),
                      ),
                    ),
                    onPressed: () {
                      fct();
                    },
                    child: TextWidget(
                        text: buttonText, color: Colors.white, textSize: 24),
                  ),
                ),
              ),
            ]),
      )),
    );
  }
}
