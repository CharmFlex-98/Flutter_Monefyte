import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/utils/filter/transactions_filter.dart';

class TypeFilter extends TransactionsFilter {
  final String _type;
  TypeFilter(this._type);

  @override
  String filterLookup() {
    return "type filter";
  }

  @override
  List<Transaction> filterTransactions(List<Transaction> transactions) {
    if (_type == "Income") {
      return transactions.where((element) => element.amount > 0).toList();
    } else if (_type == "Expenses") {
      return transactions.where((element) => element.amount < 0).toList();
    } else if (_type == "All") {
      return transactions;
    }

    return [];
  }
}
