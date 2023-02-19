class IaphubSubscriptionIntroPhase {
  /// Phase type
  final String type;
  /// Phase price
  final double price;
  /// Phase currency
  final String currency;
  /// Phase localized price
  final String localizedPrice;
  /// Phase duration cycle specified in the ISO 8601 format
  final String cycleDuration;
  /// Phase cycle count
  final int cycleCount;
  /// Phase payment type (Possible values: 'as_you_go', 'upfront')
  final String payment;

  /// Constructor from JSON
  IaphubSubscriptionIntroPhase.fromJson(Map<String, dynamic> json) 
    : type = json["type"] ?? "",
      price = json["price"] != null ? double.parse(json["price"].toString()) : 0.0,
      currency = json["currency"] ?? "",
      localizedPrice = json["localizedPrice"] ?? "",
      cycleDuration = json["cycleDuration"] ?? "",
      cycleCount = json["cycleCount"] ?? 0,
      payment = json["payment"] ?? "";

}