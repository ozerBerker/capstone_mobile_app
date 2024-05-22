import 'package:flutter/material.dart';
import 'package:mobile_app/models/transaction_model.dart';
import 'package:mobile_app/providers/transaction_provider.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:provider/provider.dart';

import 'text_widget.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget({Key? key}) : super(key: key);

  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    final transactionModel = Provider.of<TransactionModel>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Icon(
                  Icons.login,
                  size: size.width * 0.1,
                )),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'Food Bowl -',
                          color: color,
                          textSize: 16,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: 'Aus013r0ıdvnqnen0',
                          color: color,
                          textSize: 14,
                          isTitle: true,
                        ),
                      ],
                    ),
                  ),
                  TextWidget(
                    text: transactionModel.processAmount.toString(),
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  FittedBox(
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'By',
                          color: Colors.blue,
                          textSize: 16,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: '  Hadi K.',
                          color: color,
                          textSize: 14,
                          isTitle: true,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '20/03/2022',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
