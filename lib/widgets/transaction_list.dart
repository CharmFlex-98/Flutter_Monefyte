import 'package:flutter/material.dart';
import 'package:my_expenses_manager/utils/filter/transaction_reader.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:my_expenses_manager/widgets/transaction_card.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<Storage>(context);
    final reader = TransactionReader.instance();

    if (reader == null) return Container();

    final record = reader.showTransactions();

    return Column(children: [
      SizedBox(
        height: SizeController.setHeight(0.02),
      ),
      Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        height: SizeController.setHeight(0.74),
        width: double.infinity,
        child: LayoutBuilder(builder: (context, constraint) {
          return ListView.builder(
            itemCount: record.length,
            itemBuilder: (context, index) {
              return TransactionCard(
                  constraint: constraint,
                  event: record[index].event,
                  category: record[index].category,
                  id: record[index].id,
                  amount: record[index].amount,
                  date: record[index].date);
            },
          );
        }),
      ),
    ]);
  }
}
