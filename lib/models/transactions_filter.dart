import 'package:flutter/cupertino.dart';
import 'package:my_expenses_manager/models/categories.dart';
import 'package:my_expenses_manager/models/storage.dart';
import 'package:my_expenses_manager/models/transaction.dart';

class TransactionsFilter with ChangeNotifier {
  final Storage _storage = Storage();
  DateTime? _minTime;
  DateTime? _maxTime;

  TransactionsFilter() {
    _storage.init(notifyListeners);
  }

  Storage getStorage() {
    return _storage;
  }

  List<Transaction> getAllSortedTransactions() {
    List<Transaction> record = _storage.getAllTransactions();
    record.sort((b, a) => a.date.compareTo(b.date));
    return record;
  }

  List<dynamic>? getCategoryStats() {
    Map<String, double> categoryStats = {};
    double total = 0;
    // initialize
    for (String category in Categories.getCategories()) {
      categoryStats[category] = 0.0;
    }
    // add one by one
    for (Transaction transaction in getFilteredSortedTransactions()) {
      if (transaction.category == "Income") continue;
      categoryStats[transaction.category] =
          categoryStats[transaction.category]! + transaction.amount;
      total += transaction.amount;
    }

    if (total == 0) return null;
    var categoryStatsList = [];
    categoryStats.forEach((key, value) => categoryStatsList
        .add(CategoryStats(key, value, (value / total * 100))));
    return categoryStatsList;
  }

  void setTransactionsFilter({required DateTime? min, required DateTime? max}) {
    _minTime = min;
    _maxTime = max;
  }

  List<Transaction> getFilteredSortedTransactions() {
    if (_minTime == null || _maxTime == null) {
      return getAllSortedTransactions();
    }
    List<Transaction> record = getAllSortedTransactions().where((element) {
      return element.date.isBefore(_maxTime!.add(const Duration(days: 1))) &&
          element.date.isAfter(_minTime!.subtract(const Duration(seconds: 1)));
    }).toList();
    record.sort((b, a) => a.date.compareTo(b.date));

    return record;
  }

  void notify() {
    notifyListeners();
  }
}

class CategoryStats {
  final String category;
  final double amount;
  final double percentage;

  CategoryStats(this.category, this.amount, this.percentage);
}
