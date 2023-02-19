import './transaction.dart';
import './active_product.dart';

class IaphubRestoreResponse {
  /// New purchases
  final List<IaphubTransaction> newPurchases;

  /// Transferred active products
  final List<IaphubActiveProduct> transferredActiveProducts;

  /// Constructor from JSON
  IaphubRestoreResponse.fromJson(Map<String, dynamic> json)
      : newPurchases = (json["newPurchases"] ?? [])
            .map<IaphubTransaction>((data) => IaphubTransaction.fromJson(data))
            .toList(),
        transferredActiveProducts = (json["transferredActiveProducts"] ?? [])
            .map<IaphubActiveProduct>(
                (data) => IaphubActiveProduct.fromJson(data))
            .toList();
}
