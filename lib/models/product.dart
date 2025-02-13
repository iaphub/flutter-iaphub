import './subscription_intro_phase.dart';

class IaphubProduct {
  /// Product id
  final String id;

  /// Product type
  final String type;

  /// Product sku
  final String sku;

  /// Product price
  final double price;

  /// Product price currency
  final String? currency;

  /// Product localized price
  final String? localizedPrice;

  /// Product localized title
  final String? localizedTitle;

  /// Product localized description
  final String? localizedDescription;

  /// Product alias
  final String? alias;

  /// Product group id
  final String? group;

  /// Product group name
  final String? groupName;

  /// Duration of the subscription cycle specified in the ISO 8601 format
  final String? subscriptionDuration;

  /// Subscription intro phases
  final List<IaphubSubscriptionIntroPhase>? subscriptionIntroPhases;

  /// Product metadata
  final Map<String, String> metadata;

  /// Constructor from JSON
  IaphubProduct.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? "",
        type = json["type"] ?? "",
        sku = json["sku"] ?? "",
        price = json["price"] != null
            ? double.parse(json["price"].toString())
            : 0.0,
        currency = json["currency"],
        localizedPrice = json["localizedPrice"],
        localizedTitle = json["localizedTitle"],
        localizedDescription = json["localizedDescription"],
        alias = json["alias"],
        group = json["group"],
        groupName = json["groupName"],
        subscriptionDuration = json["subscriptionDuration"],
        subscriptionIntroPhases = json["subscriptionIntroPhases"]
            ?.map<IaphubSubscriptionIntroPhase>(
                (data) => IaphubSubscriptionIntroPhase.fromJson(data))
            ?.toList(),
        metadata = (json["metadata"] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
        ) ?? {};
}
