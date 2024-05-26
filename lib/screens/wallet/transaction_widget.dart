import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/transaction_model.dart';
import 'package:mobile_app/providers/transaction_provider.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../../widgets/text_widget.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({Key? key}) : super(key: key);

  String sumBalance(double old, double process) {
    return (old + process).toStringAsFixed(2);
  }

  String extractBalance(double old, double process) {
    return (old - process).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;

    final transactionModel = Provider.of<TransactionModel>(context);

    return ListTile(
      // subtitle: Text(
      //     'Current Balance: ₺${transactionModel.isItInflow ? sumBalance(transactionModel.oldAmount, transactionModel.processAmount) : extractBalance(transactionModel.oldAmount, transactionModel.processAmount)}'),
      // leading: Icon(transactionModel.isItInflow ? Icons.login : Icons.logout),
      leading: Image.asset(
        transactionModel.isItInflow
            ? 'assets/images/add-balance.png'
            : 'assets/images/payment.png',
      ),
      title: TextWidget(
        text: GlobalMethods.orderDateToShow(transactionModel.processDate),
        color: color,
        textSize: 18,
      ),
      trailing: TextWidget(
        text: (transactionModel.isItInflow ? '+ ' : '- ') +
            '${transactionModel.processAmount.toStringAsFixed(2)}',
        color: transactionModel.isItInflow ? Colors.green : Colors.red,
        textSize: 18,
      ),
    );
  }
}
