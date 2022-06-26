import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/utils/filter/date_filter.dart';
import 'package:my_expenses_manager/utils/filter/transaction_reader.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:provider/provider.dart';

class HistoryFilter extends StatefulWidget {
  const HistoryFilter({Key? key}) : super(key: key);

  @override
  _HistoryFilterState createState() => _HistoryFilterState();
}

class _HistoryFilterState extends State<HistoryFilter> {
  int _selectedIndex = 0;
  final List<String> buttonsText = [
    "1 month",
    "3 months",
    "6 months",
    "1 year",
    "all"
  ];
  DateTime? minTime = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  DateTime? maxTime = DateTime.now();

  void _presentDatePicker(Storage storage, String periodType) {
    showDatePicker(
            context: context,
            initialDate: maxTime != null ? maxTime! : DateTime.now(),
            firstDate: (periodType == "max" && minTime != null)
                ? minTime!
                : DateTime(2020),
            lastDate: (periodType == "min" && maxTime != null)
                ? maxTime!
                : DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        if (periodType == "min") {
          minTime = pickedDate;
        } else if (periodType == "max") {
          maxTime = pickedDate;
        }

        getFilteredData(storage, minTime, maxTime);
      });
    });
  }

  void _setFixPeriod(Storage storage, int index) {
    if (index == 0) {
      _selectedIndex = 0;
      minTime = DateTime(
          DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
      maxTime = DateTime.now();
    } else if (index == 1) {
      _selectedIndex = 1;
      minTime = DateTime(
          DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
      maxTime = DateTime.now();
    } else if (index == 2) {
      _selectedIndex = 2;
      minTime = DateTime(
          DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
      maxTime = DateTime.now();
    } else if (index == 3) {
      _selectedIndex = 3;
      minTime = DateTime(
          DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
      maxTime = DateTime.now();
    } else {
      _selectedIndex = 4;
      minTime = null;
      maxTime = null;
    }

    setState(() {
      getFilteredData(storage, minTime, maxTime);
    });
  }

  void getFilteredData(Storage storage, DateTime? minTime, DateTime? maxTime) {
    DateFilter dateFilter = DateFilter(minTime, maxTime);
    TransactionReader? reader = TransactionReader.instance();
    if (reader == null) return;

    reader.addFilter(dateFilter);
    storage.notify();
  }

  Widget _dateTextBox(Storage storage, DateTime? time, String periodType) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: nMbox,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    time != null ? DateFormat("dd-MM-yyyy").format(time) : "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(2),
            decoration: nMbox,
            child: IconButton(
              icon: const FittedBox(child: Icon(Icons.calendar_today)),
              onPressed: () {
                _presentDatePicker(storage, periodType);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeToggleButtons(Storage storage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var i = 0; i < buttonsText.length; i++)
          makeButton(storage, i, buttonsText[i])
      ],
    );
  }

  Widget makeButton(Storage storage, int index, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _setFixPeriod(storage, index);
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: _selectedIndex == index ? nMboxInvert : nMbox,
          child: FittedBox(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Text(text))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Provider.of<Storage>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //fix search
        _makeToggleButtons(storage),
        Container(
          height: SizeController.setHeight(0.02),
        ),
        //custom search and show bar
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dateTextBox(storage, minTime, "min"),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8),
                    child: Text(
                      '~',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  _dateTextBox(storage, maxTime, "max"),
                ],
              )),
        ),
      ],
    );
  }
}
