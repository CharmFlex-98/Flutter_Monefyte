import 'package:my_expenses_manager/models/transaction.dart';

abstract class TransactionsFilter {
  String filterLookup();
  List<Transaction> filterTransactions(List<Transaction> transactions);
}
