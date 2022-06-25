import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_manager/models/categories.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/models/transactions_filter.dart';
import 'package:my_expenses_manager/models/utilities.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartStatistic extends StatefulWidget {
  const PieChartStatistic({Key? key}) : super(key: key);

  @override
  State<PieChartStatistic> createState() => _PieChartStatisticState();
}

class _PieChartStatisticState extends State<PieChartStatistic> {
  Map<String, MaterialColor> categoryColors = Categories.getCategoryColors();
  List<String> categories = Categories.getCategories();
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  PieChartSectionData pieChartSectionData(
      String category, double value, MaterialColor color) {
    return PieChartSectionData(
      radius: SizeController.setHeight(0.2),
      color: color,
      value: value,
      title: category,
    );
  }

  double _getAmount(double amount) {
    if (amount == 0) return amount;
    return -1 * amount;
  }

  Widget categoryLabel(double amount, MaterialColor color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          Expanded(
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  "${CurrencyFormatter.getCurrencySymbol()}${NumberFormat.currency(symbol: '').format(_getAmount(amount))}",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget labelsContainer(Map<String, double> categoryStats) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
        color: CustomColors.lightBrown,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      width: double.infinity,
      height: SizeController.setHeight(0.3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                for (int i = 0; i < (categories.length / 2).round(); i++)
                  categoryLabel(categoryStats[categories[i]]!,
                      categoryColors[categories[i]]!),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                for (int i = (categories.length / 2).round();
                    i < categories.length;
                    i++)
                  categoryLabel(categoryStats[categories[i]]!,
                      categoryColors[categories[i]]!),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryStats =
        Provider.of<TransactionsFilter>(context).getCategoryStats();

    return Container(
        padding: const EdgeInsets.all(10),
        height: SizeController.setHeight(0.78),
        child: Container(
          decoration: nMboxInvert,
          child: categoryStats == null
              ? Center(
                  child: SizedBox(
                      height: SizeController.setHeight(0.4),
                      child: Image.asset(
                        'assets/no_result.png',
                        fit: BoxFit.contain,
                      )),
                )
              : SfCircularChart(
                  title: ChartTitle(
                      text:
                          'Total Expenses (${CurrencyFormatter.getCurrencyFormat()})'),
                  palette: Palette.getColorPalette(),
                  tooltipBehavior: _tooltipBehavior,
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: [
                    PieSeries(
                      animationDuration: 500,
                      explode: true,
                      dataSource: categoryStats,
                      xValueMapper: (data, _) => data.category,
                      yValueMapper: (data, _) => data.amount.abs(),
                      dataLabelMapper: (data, _) =>
                          '${data.percentage.abs().toStringAsFixed(1)}%',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      enableTooltip: true,
                    )
                  ],
                ),
        ));
  }
}
