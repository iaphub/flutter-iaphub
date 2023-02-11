
class IaphubError implements Exception {
  final String message;
  final String code;
  final String? subcode;
  final Map<String, dynamic>? params;

  /**
   * Constructor from JSON
   */
  IaphubError.fromJson(Map<String, dynamic> json)
    : message = json["message"] ?? "No message",
      code = json["code"] ?? "unexpected",
      subcode = json["subcode"],
      params = json["params"];

  @override
  String toString() => '$message (code: $code, subcode: $subcode)';
}