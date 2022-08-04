import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/utils/filter/transactions_filter.dart';

import '../storage.dart';

// make this as singleton
class TransactionReader {
  static TransactionReader? transactionReader;
  late final Storage _storage;
  final List<TransactionsFilter> _filters = [];

  TransactionReader._(this._storage);

  static void initReader({Storage? storage}) {
    if (transactionReader == null && storage != null) {
      transactionReader = TransactionReader._(storage);
    }
  }

  bool hasFilter(TransactionsFilter filter) {
    return _filters
            .where((element) => element.filterLookup() == filter.filterLookup())
            .length <=
        1;
  }

  TransactionsFilter? getFilter(String filterLookup) {
    return _filters
        .firstWhere((element) => element.filterLookup() == filterLookup);
  }

  static TransactionReader? instance() {
    return transactionReader;
  }

  void addFilter(TransactionsFilter filter) {
    removeFilter(filter);
    _filters.add(filter);
  }

  void removeFilter(TransactionsFilter filter) {
    if (hasFilter(filter)) {
      _filters.removeWhere(
          (element) => element.filterLookup() == filter.filterLookup());
    }

    // only one of the type or category filter is allow
    // so we need to check it
    removeReduntantFilter(filter);
  }

  void removeReduntantFilter(TransactionsFilter currentFilter) {
    if (currentFilter.filterLookup() == "type filter") {
      _filters.removeWhere(
          (element) => element.filterLookup() == "category filter");
    } else if (currentFilter.filterLookup() == "category filter") {
      _filters
          .removeWhere((element) => element.filterLookup() == "type filter");
    }
  }

  void sortDescending(List<Transaction> transactions) {
    transactions.sort((b, a) => a.date.compareTo(b.date));
  }

  void sortAscending(List<Transaction> transactions) {
    transactions.sort((a, b) => a.date.compareTo(b.date));
  }

  List<Transaction> showTransactions({bool descending = true}) {
    List<Transaction> transactions = _storage.getAllTransactions();

    // filtering
    for (TransactionsFilter filter in _filters) {
      transactions = filter.filterTransactions(transactions);
    }

    // sorting
    if (descending) {
      sortDescending(transactions);
    } else {
      sortAscending(transactions);
    }

    return transactions;
  }
}
