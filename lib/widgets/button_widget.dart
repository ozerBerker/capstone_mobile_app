import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.fct,
    required this.buttonText,
    this.primary = Colors.white38,
  });
  final Function fct;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          fct();
        },
        child: TextWidget(text: buttonText, color: Colors.white, textSize: 18),
      ),
    );
  }
}
