import 'package:book_beauty/models/transaction.dart';
import 'package:book_beauty/providers/base_provider.dart';

class TransactionProvider extends BaseProvider<Transaction> {
  TransactionProvider() : super("Transaction");

  @override
  Transaction fromJson(data) {
    return Transaction.fromJson(data);
  }
}
