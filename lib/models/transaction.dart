import "package:hive/hive.dart";

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String event;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  Transaction(
      {required this.id,
      required this.event,
      required this.amount,
      required this.category,
      required this.date});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "event": event,
      "amount": amount,
      "category": category,
      "date": date.toIso8601String()
    };
  }

  static Transaction fromDynamic(Map<String, dynamic> item) {
    return Transaction(
        id: item['id'],
        event: item['event'],
        amount: item['amount'].toDouble(),
        category: item['category'],
        date: DateTime.parse(item['date']));
  }
}
