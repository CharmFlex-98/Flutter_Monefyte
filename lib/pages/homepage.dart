import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:my_expenses_manager/pages/new_transaction_page.dart';
import 'package:my_expenses_manager/widgets/drawer.dart';
import 'package:my_expenses_manager/widgets/filter_widget.dart';
import 'package:my_expenses_manager/widgets/line_chart_widget.dart';
import 'package:my_expenses_manager/widgets/loading_widget.dart';
import 'package:my_expenses_manager/widgets/transaction_list.dart';
import 'package:provider/provider.dart';
import '../widgets/piechart_statistic.dart';
import '../widgets/history_filter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime onBackTime = DateTime.now();
  final List<Widget> _bottomTabList = [
    const PieChartStatistic(),
    const LineChartWidget(),
    const TransactionList()
  ];
  int currentTabIndex = 0;

  void openFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return const FilterWidget();
        });
  }

  void changeTab(index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  void go2NewTransactionPage(BuildContext context) {
    Navigator.of(context).pushNamed(NewTransactionPage.routeName);
  }

  Future<void> closeAction() async {
    Fluttertoast.cancel();
    Storage storage = Provider.of<Storage>(context, listen: false);
    Fluttertoast.showToast(
        msg: "Trying to save data on server. Please wait....");
    LoadingWidget.show(context);
    await storage.sync();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeController.init(context); //get screen size relative to homepage

    return WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(onBackTime);
          onBackTime = DateTime.now();

          if (difference > const Duration(seconds: 2)) {
            Fluttertoast.showToast(msg: "Press again to exit");
            return false;
          } else {
            return closeAction().then((_) {
              Fluttertoast.cancel();
              return true;
            }).catchError((error) {
              Navigator.of(context).pop();
              Fluttertoast.cancel();
              return true;
            });
          }
        },
        child: Scaffold(
          //color here
          backgroundColor: mC,
          drawer: const SideDrawer(),
          appBar: AppBar(
            title: const Text("Monefyte"),
            actions: [
              IconButton(
                  onPressed: openFilter, icon: const Icon(Icons.filter_alt))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: SizeController.setHeight(0.02),
                ),
                Container(
                    height: SizeController.setHeight(0.20),
                    padding: const EdgeInsets.all(5),
                    decoration: nMboxInvert,
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: const HistoryFilter()),
                _bottomTabList[currentTabIndex],
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: kBottomNavigationBarHeight,
            child: BottomNavigationBar(
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              backgroundColor: CustomColors.darkBlue,
              currentIndex: currentTabIndex,
              onTap: (index) => changeTab(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.pie_chart,
                  ),
                  label: "Pie Chart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart),
                  label: "Line Chart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.receipt_long,
                  ),
                  label: "Expenses",
                ),
              ],
            ),
          ),

          floatingActionButton: DraggableFab(
            child: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepOrange,
              onPressed: () => go2NewTransactionPage(context),
              child: const Icon(
                Icons.add,
              ),
            ),
          ),
        ));
  }
}
