import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/utils/filter/transactions_filter.dart';

class DateFilter extends TransactionsFilter {
  final DateTime? _minTime;
  final DateTime? _maxTime;

  DateFilter(this._minTime, this._maxTime);

  @override
  List<Transaction> filterTransactions(List<Transaction> transactions) {
    if (_minTime == null || _maxTime == null) {
      return transactions;
    }

    List<Transaction> record = transactions.where((element) {
      return element.date.isBefore(_maxTime!.add(const Duration(days: 1))) &&
          element.date.isAfter(_minTime!.subtract(const Duration(seconds: 1)));
    }).toList();

    return record;
  }

  @override
  String filterLookup() {
    return "date filter";
  }
}
