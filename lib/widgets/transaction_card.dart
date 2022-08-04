import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:my_expenses_manager/pages/new_transaction_page.dart';
import 'package:my_expenses_manager/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatelessWidget {
  final BoxConstraints constraint;
  final String event;
  final String category;
  final String id;
  final double amount;
  final DateTime date;

  const TransactionCard(
      {Key? key,
      required this.constraint,
      required this.event,
      required this.category,
      required this.id,
      required this.amount,
      required this.date})
      : super(key: key);

  void deleteTransaction(context) {
    final storage = Provider.of<Storage>(context, listen: false);
    storage.removeTransaction(id);
  }

  Future pressDelete(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const MessageDialog(
              title: "Alert",
              message: "You are going to delete this transaction.");
        }).then((confirmDelete) {
      if (!confirmDelete[0]) return;
      deleteTransaction(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: nMbox,
      padding: const EdgeInsets.all(5),
      height: constraint.maxHeight / 5,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(NewTransactionPage.routeName, arguments: id);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: CustomColors.greyBlue,
                  foregroundColor: Colors.white,
                  radius: 25,
                  child: FittedBox(
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            event,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          "${DateFormat("LLLL").format(date)} ${DateFormat("yyyy").format(date)}",
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          amount < 0
                              ? "-${CurrencyFormatter.getCurrencySymbol()}${NumberFormat.currency(symbol: '').format(-1 * amount)}"
                              : "+${CurrencyFormatter.getCurrencySymbol()}${NumberFormat.currency(symbol: '').format(amount)}",
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: amount < 0 ? Colors.red : Colors.green[600],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: IconButton(
                  onPressed: () {
                    pressDelete(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 30,
                    color: CustomColors.darkRed,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
