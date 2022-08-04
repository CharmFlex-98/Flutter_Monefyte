import 'package:flutter/material.dart';
import 'package:my_expenses_manager/models/categories.dart';
import 'package:my_expenses_manager/utils/utilities.dart';

class CategoryDropDownMenu extends StatefulWidget {
  final Function _selectCategory;
  final String? selectedCategory;

  const CategoryDropDownMenu(this._selectCategory,
      {this.selectedCategory, Key? key})
      : super(key: key);

  @override
  _CategoryDropDownMenuState createState() => _CategoryDropDownMenuState();
}

class _CategoryDropDownMenuState extends State<CategoryDropDownMenu> {
  final _categories = Categories.getCategories();
  late Function _selectCategory;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectCategory = widget._selectCategory;
    _selectedCategory = widget.selectedCategory;
  }

  DropdownMenuItem<String> buildMenuItem(String category) {
    return DropdownMenuItem(
      value: category,
      child: Text(category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.lightBrown,
          border: Border.all(
            width: 1,
          )),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuMaxHeight: SizeController.setHeight(0.7),
          borderRadius: BorderRadius.circular(10),
          items: [for (String category in _categories) buildMenuItem(category)],
          onChanged: (value) => setState(() {
            _selectCategory(value);
            _selectedCategory = value;
          }),
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: CustomColors.lightBrown,
          hint: const Text("Category"),
        ),
      ),
    );
  }
}
