import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/utils/filter/date_filter.dart';
import 'package:my_expenses_manager/utils/filter/transaction_reader.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:provider/provider.dart';

class StatTable extends StatefulWidget {
  const StatTable({Key? key}) : super(key: key);

  @override
  State<StatTable> createState() => _StatTableState();
}

class _StatTableState extends State<StatTable> {
  final List<String> headers = [
    'Open',
    'Close',
    'Pos',
    'Currency',
    'Strategy',
    'P/L (\$)'
  ];
  late List<Transaction> transactions;
  TransactionReader? reader;

  int? _sortColumnIndex;
  bool isAscending = false;

  DataCell generateCell(String item) {
    return DataCell(Text(
      item,
    ));
  }

  DataRow getFinalRow() {
    return DataRow(cells: [
      const DataCell(Text("")),
      const DataCell(Text("Total:")),
      DataCell(Text(getTotalAmount(transactions).toString())),
    ]);
  }

  double getTotalAmount(List<Transaction> transactions) {
    double total = 0;
    for (Transaction transaction in transactions) {
      total += transaction.amount;
    }

    return total;
  }

  // this function is used by flutter
  onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      transactions.sort((record1, record2) {
        return ascending
            ? record1.date.compareTo(record2.date)
            : record2.date.compareTo(record1.date);
      });
    }

    if (columnIndex == 1) {
      transactions.sort((record1, record2) {
        return ascending
            ? record1.category.compareTo(record2.category)
            : record2.category.compareTo(record1.category);
      });
    }

    if (columnIndex == 2) {
      transactions.sort((record1, record2) {
        return ascending
            ? record1.amount.compareTo(record2.amount)
            : record2.amount.compareTo(record1.amount);
      });
    }
    setState(() {
      _sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  @override
  void initState() {
    reader = TransactionReader.instance();
    if (reader == null) super.initState();

    transactions = reader!.showTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Storage>(context);

    DateFilter? dateFilter = reader?.getFilter("date filter") as DateFilter?;
    if (dateFilter == null) return Container();

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Expanded(
                  child: Text(
                dateFilter.getPeriodText(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: DataTable(
                  decoration: nMbox,
                  columnSpacing: 8,
                  sortAscending: isAscending,
                  sortColumnIndex: _sortColumnIndex,
                  columns: headers
                      .map((header) => DataColumn(
                            label: Text(header),
                            onSort: onSort,
                          ))
                      .toList(),
                  rows: [
                    ...transactions
                        .map(
                          (record) => DataRow(
                              cells: [
                            DateFormat("yyyyMMdd").format(record.date),
                            record.category,
                            record.amount.toString(),
                          ].map((e) => generateCell(e)).toList()),
                        )
                        .toList(),
                    getFinalRow(),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
