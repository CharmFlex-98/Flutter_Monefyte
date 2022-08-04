import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:my_expenses_manager/widgets/loading_widget.dart';
import 'package:my_expenses_manager/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  static const routeName = "/SettingPage";

  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String selectedCurrency = CurrencyFormatter.getCurrencyFormat();
  String currencySymbol = CurrencyFormatter.getCurrencySymbol();
  // bool isLoading = false;

  void _showCurrencyPicker() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        setState(() {
          selectedCurrency = currency.code;
          currencySymbol = currency.symbol;
        });
      },
    );
  }

  Future _showFormatDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const MessageDialog(
              title: "Alert",
              message: "You are going to delete all transactions!");
        }).then((confirmDelete) {
      if (!confirmDelete[0]) return;
      format();
    });
  }

  void format() async {
    final storage = Provider.of<Storage>(context, listen: false);
    LoadingWidget.show(context);
    await storage.removeAllTransactions();
    storage.notify();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void applySetting() {
    final storage = Provider.of<Storage>(context, listen: false);
    CurrencyFormatter.setCurrencyFormat(selectedCurrency, currencySymbol);
    storage.notify();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.paleWhite,
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Currency :",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(3),
                    color: Colors.grey,
                    child: Text(
                      selectedCurrency,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                        onPressed: () {
                          _showCurrencyPicker();
                        },
                        child: const Text(
                          "Change",
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeController.setHeight(0.1),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[900]),
              ),
              onPressed: () {
                _showFormatDialog();
              },
              child: const Text("Clear Transactions"),
            ),
            SizedBox(
              height: SizeController.setHeight(0.5),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    applySetting();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Apply"),
                      Icon(Icons.done),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
