import 'package:flutter/material.dart';
import 'package:my_expenses_manager/utils/utilities.dart';

class Categories {
  static final Map<String, MaterialColor> _categories = {
    "Beauty": Colors.blue,
    "Clothing": Colors.yellow,
    "Entertainment": Colors.green,
    "Food": Colors.lightGreen,
    "Gift/Charity": Colors.brown,
    "Groceries": Colors.lime,
    "Insurance": Colors.indigo,
    "Investment": Colors.grey,
    "Housing": Colors.orange,
    "Loan Repayment": Colors.red,
    "Medical": CustomColors.darkRed,
    "Rental": Colors.blueGrey,
    "Self-Development": Colors.deepPurple,
    "Sports": Colors.purple,
    "Transportation": Colors.cyan,
    "Travelling": Colors.pink,
    "Utilities": Colors.teal,
    "Other": Colors.deepOrange,
  };
  static List<String> _selectedCategories = [];
  static bool isInitialized = false;

  static List<String> getCategories() {
    return [..._categories.keys];
  }

  static List<String> getTransactionType() {
    return ["All", "Expenses", "Income"];
  }

  static Map<String, MaterialColor> getCategoryColors() {
    return {..._categories};
  }

  static List<String> initialize() {
    isInitialized = true;
    _selectedCategories.add("All");
    return _selectedCategories;
  }

  static List<String> selectedCategories() {
    if (!isInitialized) {
      return initialize();
    }
    return _selectedCategories;
  }

  static void saveSelectedCat(List<String> categories) {
    _selectedCategories = categories;
  }
}
