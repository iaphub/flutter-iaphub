import './error.dart';

class IaphubBillingStatus {
  /// Billing error
  final IaphubError? error;

  /// Filtered products ids
  final List<String> filteredProductIds;

  /// Constructor from JSON
  IaphubBillingStatus.fromJson(Map<String, dynamic> json)
      : error =
            json["error"] != null ? IaphubError.fromJson(json["error"]) : null,
        filteredProductIds = (json["filteredProductIds"] ?? []).cast<String>();
}
