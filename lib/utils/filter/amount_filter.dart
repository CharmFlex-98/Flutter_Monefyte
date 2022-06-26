import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/utils/filter/transactions_filter.dart';

class AmountFilter extends TransactionsFilter {
  final double _minAmount;
  final double _maxAmount;

  AmountFilter(this._minAmount, this._maxAmount);
  @override
  List<Transaction> filterTransactions(List<Transaction> transactions) {
    return transactions.where((element) {
      return element.amount <= _maxAmount || element.amount >= _minAmount;
    }).toList();
  }

  @override
  String filterLookup() {
    return "amount filter";
  }
}
