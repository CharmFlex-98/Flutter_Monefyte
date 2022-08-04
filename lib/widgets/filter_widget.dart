import 'package:flutter/material.dart';
import 'package:my_expenses_manager/models/categories.dart';
import 'package:my_expenses_manager/models/modern_ui.dart';
import 'package:my_expenses_manager/utils/filter/category_filter.dart';
import 'package:my_expenses_manager/utils/filter/transaction_reader.dart';
import 'package:my_expenses_manager/utils/filter/type_filter.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late List<String> _selectedCategories;

  @override
  void initState() {
    _selectedCategories = Categories.selectedCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mC,
      title: const Text(
        'Filter by Categories',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: SizeController.setWidth(context, 0.6),
        height: SizeController.setHeight(0.4),
        child: ListView(
          shrinkWrap: true,
          children: [
            ...Categories.getTransactionType(),
            ...Categories.getCategories()
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration:
                          _selectedCategories.contains(e) ? nMboxInvert : nMbox,
                      child: ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: () {
                          setState(() {
                            if (_selectedCategories.contains(e)) {
                              _selectedCategories.remove(e);
                            } else {
                              _selectedCategories.add(e);
                              if (!Categories.getTransactionType()
                                  .contains(e)) {
                                _selectedCategories.remove("Expenses");
                                _selectedCategories.remove("Income");
                                _selectedCategories.remove("All");
                              } else {
                                _selectedCategories
                                    .removeWhere((element) => element != e);
                              }
                            }
                          });
                        },
                        title: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            e.isEmpty ? "(No Strategy)" : e,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
      actions: [
        Container(
          decoration: nMbox,
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel")),
        ),
        Container(
            decoration: nMbox,
            child:
                TextButton(onPressed: applyFilter, child: const Text('Apply')))
      ],
    );
  }

  void applyFilter() {
    TransactionReader? reader = TransactionReader.instance();
    if (reader == null) return;

    Categories.saveSelectedCat(_selectedCategories);
    if (_selectedCategories.contains("Income") ||
        _selectedCategories.contains("Expenses") ||
        _selectedCategories.contains("All")) {
      if (_selectedCategories.length != 1) return;
      reader.addFilter(TypeFilter(_selectedCategories[0]));
    } else {
      reader.addFilter(CategoryFilter(_selectedCategories));
    }
    Provider.of<Storage>(context, listen: false).notify();
    Navigator.of(context).pop();
  }
}
