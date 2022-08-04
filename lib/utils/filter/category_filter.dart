import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/utils/filter/transactions_filter.dart';

class CategoryFilter extends TransactionsFilter {
  final List<String> _categories;

  CategoryFilter(this._categories);

  @override
  List<Transaction> filterTransactions(List<Transaction> transactions) {
    return transactions.where((element) {
      return _categories.contains(element.category);
    }).toList();
  }

  @override
  String filterLookup() {
    return "category filter";
  }
}
