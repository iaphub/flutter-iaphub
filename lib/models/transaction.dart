import './active_product.dart';

class IaphubTransaction extends IaphubActiveProduct {
  /**
   * Webhook status of the transction
   */
  final String? webhookStatus;
  /**
   * Internal IAPHUB user id
   */
  final String? user;

  /**
   * Constructor from JSON
   */
  IaphubTransaction.fromJson(Map<String, dynamic> json)
    : webhookStatus = json['webhookStatus'],
      user = json['user'],
      super.fromJson(json);

}