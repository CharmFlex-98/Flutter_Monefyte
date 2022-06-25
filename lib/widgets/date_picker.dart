import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final Function _selectDate;
  final DateTime? selectedDate;

  const DatePicker(this._selectDate, {this.selectedDate, Key? key})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late Function _selectDate;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _selectDate = widget._selectDate;
    selectedDate = widget.selectedDate;
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      _selectDate(pickedDate);
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          selectedDate != null
              ? DateFormat("EEEE     dd-MM-yyyy").format(selectedDate!)
              : "No Date Chosen",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        IconButton(
          color: Colors.red,
          icon: const Icon(Icons.calendar_today),
          onPressed: _presentDatePicker,
        ),
      ],
    );
  }
}
