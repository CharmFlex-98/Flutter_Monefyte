import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/models/transactions_filter.dart';
import 'package:my_expenses_manager/models/utilities.dart';
import 'package:provider/provider.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late DateTime startDate;

  double spent = 0;

  double income = 0;

  List<FlSpot> _getChartData(List<Transaction> transactions) {
    Map<DateTime, double> dailyAmount = {};
    List<FlSpot> spots = [];
    startDate = transactions[0].date;
    DateTime prevDate = startDate;
    double amount = 0;
    spent = 0;
    income = 0;

    for (var transaction in transactions) {
      if (transaction.date == prevDate) {
        amount += transaction.amount;
      } else {
        dailyAmount[prevDate] = amount;
        prevDate = transaction.date;
        amount += transaction.amount;
      }
      if (transaction.amount < 0) {
        spent += transaction.amount.abs();
      } else {
        income += transaction.amount;
      }
    }
    dailyAmount[prevDate] = amount;

    for (var day in dailyAmount.keys) {
      spots.add(FlSpot(
          day.difference(startDate).inDays.toDouble(), dailyAmount[day]!));
    }
    return spots;
  }

  List<double> _getDataProperties(
      List<Transaction> transactions, List<FlSpot> spots) {
    List<double> properties = [];
    properties.add(spots.reduce((a, b) => a.x <= b.x ? a : b).x); //find minX
    properties.add(spots.reduce((a, b) => a.x >= b.x ? a : b).x); // find maxX,
    properties.add(spots.reduce((a, b) => a.y <= b.y ? a : b).y); //find minY
    properties.add(spots.reduce((a, b) => a.y >= b.y ? a : b).y); // find maxY

    return properties;
  }

  Widget cardLabel(
      BuildContext context, Icon icon, String amount, Color color) {
    return Container(
      decoration: nMboxInvert,
      height: SizeController.setHeight(0.06),
      width: SizeController.setWidth(context, 0.4),
      padding: const EdgeInsets.all(7),
      child: Row(children: [
        FittedBox(
          child: icon,
        ),
        Expanded(
          child: FittedBox(
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = Provider.of<TransactionsFilter>(context)
        .getFilteredSortedTransactions();
    if (filteredData.isEmpty) {
      return SizedBox(
          height: SizeController.setHeight(0.78),
          child: Center(
            child: SizedBox(
                height: SizeController.setHeight(0.4),
                child: Image.asset(
                  'assets/no_result.png',
                  fit: BoxFit.contain,
                )),
          ));
    }
    final spotsData = _getChartData(filteredData);
    final dataProps = _getDataProperties(filteredData, spotsData);
    final extraSpace = (dataProps[3] - dataProps[2]) * 0.1 + 1;

    return SizedBox(
      height: SizeController.setHeight(0.78),
      child: Column(children: [
        SizedBox(
          height: SizeController.setHeight(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              cardLabel(
                  context,
                  const Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                  ),
                  "${CurrencyFormatter.getCurrencySymbol()}${NumberFormat.currency(symbol: '').format(income)}",
                  Colors.green),
              cardLabel(
                  context,
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                  ),
                  "${CurrencyFormatter.getCurrencySymbol()}${NumberFormat.currency(symbol: '').format(spent)}",
                  Colors.red),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 5),
            child: LineChart(LineChartData(
                titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                        reservedSize: SizeController.setHeight(0.07),
                        showTitles: true,
                        interval: (dataProps[1] - dataProps[0] + 1) * 0.25,
                        getTitles: (value) {
                          return DateFormat('LLL dd\nyyyy').format(
                              startDate.add(Duration(days: value.toInt())));
                        })),
                minX: dataProps[0],
                maxX: dataProps[1] + 1,
                minY: dataProps[2] - extraSpace,
                maxY: dataProps[3] + extraSpace,
                lineBarsData: [
                  LineChartBarData(
                    show: true,
                    spots: spotsData,
                    isStrokeCapRound: true,
                    colors: [Colors.red],
                    barWidth: 1,
                    dotData:
                        FlDotData(show: spotsData.length == 1 ? true : false),
                  )
                ])),
          ),
        ),
      ]),
    );
  }
}
