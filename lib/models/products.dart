import './product.dart';
import './active_product.dart';

class IaphubProducts {
  /// Products for sale
  final List<IaphubProduct> productsForSale;
  /// Active products
  final List<IaphubActiveProduct> activeProducts;

  /// Constructor from JSON
  IaphubProducts.fromJson(Map<String, dynamic> json)
    : productsForSale = (json["productsForSale"] ?? []).map<IaphubProduct>((data) => IaphubProduct.fromJson(data)).toList(),
      activeProducts = (json["activeProducts"] ?? []).map<IaphubActiveProduct>((data) => IaphubActiveProduct.fromJson(data)).toList();
}