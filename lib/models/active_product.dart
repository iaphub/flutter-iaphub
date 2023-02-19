import './product.dart';

class IaphubActiveProduct extends IaphubProduct {
  /// Purchase id
  final String? purchase;

  /// Purchase date (ISO format)
  final String? purchaseDate;

  /// Platform of the purchase
  final String? platform;

  /// If it has been purchased using a promo code
  final bool isPromo;

  /// Promo code used for the purchase
  ///
  /// (Android: only available for subscriptions vanity codes, not available for one time codes) (iOS: the value is the offer reference name)
  final String? promoCode;

  /// Subscription original purchase id
  final String? originalPurchase;

  /// Subscription expiration date
  final String? expirationDate;

  /// Returns if the subscription will auto renew
  final bool isSubscriptionRenewable;

  /// True if the subscription is shared by a family member (iOS subscriptions only)
  final bool isFamilyShare;

  /// Subscription product of the next renewal (only defined if different than the current product)
  final String? subscriptionRenewalProduct;

  /// SubscriptionRenewalProduct sku
  final String? subscriptionRenewalProductSku;

  /// Subscription state ("active", "retry_period", "grace_period", "paused")
  final String? subscriptionState;

  /// Subscription period type ("normal", "trial", "intro"
  final String? subscriptionPeriodType;

  /// Constructor from JSON
  IaphubActiveProduct.fromJson(Map<String, dynamic> json)
      : purchase = json["purchase"],
        purchaseDate = json["purchaseDate"],
        platform = json["platform"],
        isPromo = json["isPromo"] ?? false,
        promoCode = json["promoCode"],
        originalPurchase = json["originalPurchase"],
        expirationDate = json["expirationDate"],
        isSubscriptionRenewable = json["isSubscriptionRenewable"] ?? false,
        isFamilyShare = json["isFamilyShare"] ?? false,
        subscriptionRenewalProduct = json["subscriptionRenewalProduct"],
        subscriptionRenewalProductSku = json["subscriptionRenewalProductSku"],
        subscriptionState = json["subscriptionState"],
        subscriptionPeriodType = json["subscriptionPeriodType"],
        super.fromJson(json);
}
