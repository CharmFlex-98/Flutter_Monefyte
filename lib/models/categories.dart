import 'package:flutter/material.dart';
import 'package:my_expenses_manager/utils/utilities.dart';

class Categories {
  static final Map<String, MaterialColor> _categories = {
    "Clothing": Colors.yellow,
    "Entertainment": Colors.green,
    "Food": Colors.lightGreen,
    "Housing": Colors.orange,
    "Insurance": Colors.indigo,
    "Medical": CustomColors.darkRed,
    "Self-Development": Colors.deepPurple,
    "Transportation": Colors.cyan,
    "Travelling": Colors.pink,
    "Utilities": Colors.teal,
    "Beauty": Colors.blue,
    "Loan Repayment": Colors.red,
    "Gift/Charity": Colors.brown,
    "Rental": Colors.blueGrey,
    "Groceries": Colors.lime,
    "Bills": Colors.deepOrange,
    "Investment": Colors.grey,
    "Other": Colors.deepOrange,
    "Sports": Colors.purple,
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
