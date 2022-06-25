import 'package:flutter/material.dart';
import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/models/transactions_filter.dart';
import 'package:my_expenses_manager/models/utilities.dart';
import 'package:my_expenses_manager/widgets/calculator.dart';
import 'package:my_expenses_manager/widgets/category_dropdrow_menu.dart';
import 'package:my_expenses_manager/widgets/date_picker.dart';
import 'package:provider/provider.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({Key? key}) : super(key: key);

  static const String routeName = "/NewTransactionPage";

  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  int _selectedTransactionType = 0;
  String? _selectedCategory;
  DateTime? _selectedDate;
  final TextEditingController event = TextEditingController();
  final TextEditingController amount = TextEditingController();
  String? transactionId; // if edit
  bool _isEditing = false;

  void import(Transaction transaction) {
    _selectedDate = transaction.date;
    event.text = transaction.event;
    amount.text = transaction.amount.abs().toStringAsFixed(2);
    if (transaction.category == "Income") {
      _selectedTransactionType = 1;
    } else {
      _selectedTransactionType = 0;
      _selectedCategory = transaction.category;
    }
  }

  void __selectTransactionType(int value) {
    setState(() {
      _selectedTransactionType = value;
    });
  }

  void _selectCategory(String category) {
    _selectedCategory = category;
  }

  void _selectDate(DateTime date) {
    _selectedDate = date;
  }

  Widget setSizedBox(double ratio) {
    return SizedBox(height: SizeController.setHeight(ratio));
  }

  void submitData(TransactionsFilter transactionFilter) {
    if (_selectedDate == null ||
        event.text.isEmpty ||
        amount.text.isEmpty ||
        double.tryParse(amount.text) == null) {
      return;
    }
    if (_selectedTransactionType == 0 && _selectedCategory == null) {
      return;
    }

    transactionFilter
        .getStorage()
        .addTransaction(
            Transaction(
                id: transactionId ?? DateTime.now().toString(),
                event: event.text,
                amount: _selectedTransactionType == 0
                    ? -double.parse(amount.text)
                    : double.parse(amount.text),
                category: _selectedTransactionType == 0
                    ? _selectedCategory!
                    : "Income",
                date: _selectedDate!),
            isUpdate: _isEditing)
        .then((_) {
      transactionFilter.notify();
      Navigator.of(context).pop();
    });
  }

  Widget _setTextField(String text, Icon icon, TextEditingController controller,
      TextInputType keyboardType, int maxInput,
      {String? hint}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLength: maxInput,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            filled: true,
            fillColor: CustomColors.lightBrown,
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.close),
            ),
            prefixIcon: icon,
            labelText: text,
            hintText: hint ?? "",
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget _setTransactionTypeRadioButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [setRadioButton("EXPENSES", 0), setRadioButton("Income", 1)],
    );
  }

  Widget setRadioButton(String text, int value) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        Radio<int>(
          activeColor: CustomColors.darkRed,
          value: value,
          groupValue: _selectedTransactionType,
          onChanged: (value) => __selectTransactionType(value!),
        )
      ],
    );
  }

  void inputCalculatedValue(double value) {
    setState(() {
      if (value.toStringAsFixed(2).length > 14 || value <= 0) {
        amount.text = 'invalid input!';
      } else {
        amount.text = value.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsFilter =
        Provider.of<TransactionsFilter>(context, listen: false);

    if (ModalRoute.of(context)?.settings.arguments != null &&
        _isEditing == false) {
      _isEditing = true;
      transactionId = ModalRoute.of(context)?.settings.arguments as String;
      import(transactionsFilter.getStorage().getTransaction(transactionId!)!);
    }

    return Scaffold(
        backgroundColor: CustomColors.paleWhite,
        appBar: AppBar(
          title: Text(_isEditing ? "Edit Transaction" : "New Transaction"),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: CustomColors.paleWhite,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _setTransactionTypeRadioButton(),
                    if (_selectedTransactionType == 0)
                      CategoryDropDownMenu(
                        _selectCategory,
                        selectedCategory: _selectedCategory,
                      ),
                    _setTextField('Event', const Icon(Icons.event), event,
                        TextInputType.name, 40),
                    Row(
                      children: [
                        Expanded(
                          child: _setTextField(
                              "Amount",
                              const Icon(Icons.money),
                              amount,
                              TextInputType.number,
                              14,
                              hint: CurrencyFormatter.getCurrencyFormat()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          child: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                        height: SizeController.setHeight(0.8),
                                        child: Calculator(
                                            inputFunction:
                                                inputCalculatedValue));
                                  });
                            },
                            icon: const Icon(Icons.calculate),
                            alignment: Alignment.center,
                          ),
                        )
                      ],
                    ),
                    DatePicker(_selectDate, selectedDate: _selectedDate),
                    ElevatedButton(
                        onPressed: () => submitData(transactionsFilter),
                        child: const Text("Confirm"))
                  ]),
            ),
          ),
        ));
  }
}
