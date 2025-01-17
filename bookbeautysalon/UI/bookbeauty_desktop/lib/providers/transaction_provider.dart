import 'package:bookbeauty_desktop/models/transaction.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class TransactionProvider extends BaseProvider<Transaction> {
  TransactionProvider() : super("Transaction");

  @override
  Transaction fromJson(data) {
    return Transaction.fromJson(data);
  }
}
