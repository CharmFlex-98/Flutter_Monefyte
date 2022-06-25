import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/models/connection.dart';

class Storage {
  late Function notify;
  final Box<Transaction> _mainStorage = Hive.box<Transaction>('mainStorage');
  final Box<Transaction> _postStorage = Hive.box<Transaction>('postStorage');
  final Box<Transaction> _patchStorage = Hive.box<Transaction>('patchStorage');
  final Box<Transaction> _delStorage = Hive.box<Transaction>('delStorage');

  void init(Function function) {
    notify = function;
  }

  Box<Transaction> getBox() {
    return _mainStorage;
  }

  Future<void> addTransaction(Transaction transaction,
      {required bool isUpdate}) async {
    await _mainStorage.put(transaction.id, transaction);

    // if not sign in
    if (!Connection.isLoggedin()) return;

    // if sign in
    Transaction copy = Transaction(
        id: transaction.id,
        event: transaction.event,
        amount: transaction.amount,
        category: transaction.category,
        date: transaction.date.add(const Duration()));

    isUpdate
        ? await _patchStorage.put(copy.id, copy)
        : await _postStorage.put(copy.id, copy);
  }

  Transaction? getTransaction(String id) {
    return _mainStorage.get(id);
  }

  List<Transaction> getAllTransactions() {
    return _mainStorage.values.toList();
  }

  Future<void> removeTransaction(String id) async {
    Transaction transaction = getTransaction(id)!;
    await _mainStorage.delete(id);

    // if not sign in
    if (!Connection.isLoggedin()) return;

    // if sign in
    Transaction copy = Transaction(
        id: transaction.id,
        event: transaction.event,
        amount: transaction.amount,
        category: transaction.category,
        date: transaction.date.add(const Duration()));

    await _delStorage.put(copy.id, copy);
    notify();
  }

  Future<void> removeAllTransactions() async {
    List<Transaction> transactions = getAllTransactions();
    await _mainStorage.clear();

    // if not sign in
    if (!Connection.isLoggedin()) return;

    // if sign in
    for (Transaction transaction in transactions) {
      Transaction copy = Transaction(
          id: transaction.id,
          event: transaction.event,
          amount: transaction.amount,
          category: transaction.category,
          date: transaction.date.add(const Duration()));
      await _delStorage.put(copy.id, copy);
    }
    notify();
  }
// ---------------------------------------
  // this is for online database

  Future<void> importTransaction() async {
    var data = await getAllTransactionsOnline();
    await _mainStorage.clear();
    for (var item in data) {
      Transaction transaction = Transaction.fromDynamic(item);
      await _mainStorage.put(transaction.id, transaction);
    }
    notify();
  }

  Future<void> reWriteDataToServer() async {
    await Connection.makeConnection().request('/transactions/reset',
        data: getAllTransactions(), options: Options(method: 'POST'));
  }

  Future<dynamic> getAllTransactionsOnline() async {
    var response = await Connection.makeConnection()
        .request('/transactions', data: {}, options: Options(method: 'GET'));
    return response.data;
  }

  Future<void> addAllTransactionsOnline(List<Transaction>? transactions) async {
    if (transactions == null) return;

    // var data = await getAllTransactionsOnline();
    // print(data);
    // await removeAllTransactionsOnline();

    // auto parsing to json, by using json.decode(). Make sure hes toJson function in target class.
    // the return json response will be parse to suitable object.
    await Connection.makeConnection().request('/transactions',
        data: transactions, options: Options(method: 'POST'));
  }

  Future<void> removeAllTransactionsOnline() async {
    await Connection.makeConnection()
        .request('/transactions', data: {}, options: Options(method: 'DELETE'));
  }

  Future<void> sync() async {
    await Connection.makeConnection().request('/transactions',
        data: _postStorage.values.toList(), options: Options(method: 'POST'));
    await _postStorage.clear();
    await Connection.makeConnection().request('/transactions',
        data: _patchStorage.values.toList(), options: Options(method: 'PATCH'));
    await _patchStorage.clear();
    await Connection.makeConnection().request('/transactions',
        data: _delStorage.keys.toList(), options: Options(method: 'DELETE'));
    await _delStorage.clear();
  }
}
