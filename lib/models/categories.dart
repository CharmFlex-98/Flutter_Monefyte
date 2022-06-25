import 'package:flutter/material.dart';
import 'package:my_expenses_manager/models/utilities.dart';

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
    "Other": Colors.deepOrange,
  };

  static List<String> getCategories() {
    return [..._categories.keys];
  }

  static Map<String, MaterialColor> getCategoryColors() {
    return {..._categories};
  }
}
