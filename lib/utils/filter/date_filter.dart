import 'package:intl/intl.dart';
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

  String getPeriodText() {
    return (_minTime != null && _maxTime != null
        ? '${DateFormat('yyyy-MM-dd').format(_minTime!)} ~ ${DateFormat('yyyy-MM-dd').format(_maxTime!)}'
        : '${DateFormat('yyyy-MM-dd').format(DateTime(1970))} ~ ${DateFormat('yyyy-MM-dd').format(DateTime.now())}');
  }

  @override
  String filterLookup() {
    return "date filter";
  }
}
