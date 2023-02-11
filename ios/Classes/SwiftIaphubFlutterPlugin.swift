import Flutter
import Iaphub

class FlutterLocalizedError: LocalizedError {
   
   let message: String
   
   init(_ message: String) {
      self.message = message
   }
   
   public var errorDescription: String? {
      get {
         return "\(self.message)"
      }
   }
   
}

public class SwiftIaphubFlutterPlugin: NSObject, FlutterPlugin, IaphubDelegate {
   
   private static var channel: FlutterMethodChannel?
   
   public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "iaphub_flutter", binaryMessenger: registrar.messenger())
      let instance = SwiftIaphubFlutterPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
      self.channel = channel
   }
   
   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let args = call.arguments as? [String: Any] ?? [String: Any]()
      
      if (call.method == "start") {
         self.start(call, result: result, args: args)
      }
      else if (call.method == "stop") {
         self.stop(call, result: result, args: args)
      }
      else if (call.method == "login") {
         self.login(call, result: result, args: args)
      }
      else if (call.method == "getUserId") {
         self.getUserId(call, result: result, args: args)
      }
      else if (call.method == "logout") {
         self.logout(call, result: result, args: args)
      }
      else if (call.method == "setDeviceParams") {
         self.setDeviceParams(call, result: result, args: args)
      }
      else if (call.method == "setUserTags") {
         self.setUserTags(call, result: result, args: args)
      }
      else if (call.method == "buy") {
         self.buy(call, result: result, args: args)
      }
      else if (call.method == "restore") {
         self.restore(call, result: result, args: args)
      }
      else if (call.method == "getActiveProducts") {
         self.getActiveProducts(call, result: result, args: args)
      }
      else if (call.method == "getProductsForSale") {
         self.getProductsForSale(call, result: result, args: args)
      }
      else if (call.method == "getProducts") {
         self.getProducts(call, result: result, args: args)
      }
      else if (call.method == "getBillingStatus") {
         self.getBillingStatus(call, result: result, args: args)
      }
      else if (call.method == "presentCodeRedemptionSheet") {
         self.presentCodeRedemptionSheet(call, result: result, args: args)
      }
      else if (call.method == "showManageSubscriptions") {
         self.showManageSubscriptions(call, result: result, args: args)
      }
      else {
         result(FlutterMethodNotImplemented)
      }
   }
   
   /**
    *  Start IAPHUB
    */
   private func start(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let appId = args["appId"] as? String ?? ""
      let apiKey = args["apiKey"] as? String ?? ""
      let userId = args["userId"] as? String
      let allowAnonymousPurchase = args["allowAnonymousPurchase"] as? Bool ?? false
      let enableDeferredPurchaseListener = args["enableDeferredPurchaseListener"] as? Bool ?? true
      let environment = args["environment"] as? String ?? "production"
      let sdkVersion = args["sdkVersion"] as? String ?? ""
      let sdk = "flutter"
      // Start SDK
      Iaphub.delegate = self
      Iaphub.start(
         appId: appId,
         apiKey: apiKey,
         userId: userId,
         allowAnonymousPurchase: allowAnonymousPurchase,
         enableDeferredPurchaseListener: enableDeferredPurchaseListener,
         environment: environment,
         sdk: sdk,
         sdkVersion: sdkVersion
      )
      // Call result
      result(nil)
   }
   
   /**
    *  Stop IAPHUB
    */
   private func stop(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      // Stop SDK
      Iaphub.stop()
      // Call result
      result(nil);
   }
   
   /**
    *  Login
    */
   private func login(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let userId = args["userId"] as? String
      
      guard let userId = userId else {
         return self.reject(result, code: "unexpected", message: "login user id missing")
      }
      
      Iaphub.login(userId: userId, { (err) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, nil)
      })
   }
   
   /**
    *  Get user id
    */
   private func getUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let userId = Iaphub.getUserId()
      
      guard let userId = Iaphub.getUserId() else {
         return self.reject(result, code: "start_missing", message: "iaphub not started")
      }
      result(userId)
   }
   
   /**
    *  Logout
    */
   private func logout(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      Iaphub.logout()
      self.resolve(result, nil)
   }
   
   /**
    *  Set device params
    */
   private func setDeviceParams(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      guard let params = args as? Dictionary<String, String> else {
         return self.reject(result, code: "unexpected", message: "params must be a string")
      }
      
      Iaphub.setDeviceParams(params: params)
      self.resolve(result, nil)
   }
   
   /**
    *  Set user tags
    */
   private func setUserTags(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      guard let tags = args as? Dictionary<String, String> else {
         return self.reject(result, code: "unexpected", message: "tags must be a string")
      }
      
      Iaphub.setUserTags(tags: tags, { (err) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, nil)
      })
   }
   
   /**
    *  Buy
    */
   private func buy(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let sku = args["sku"] as? String ?? ""
      let crossPlatformConflict = args["crossPlatformConflict"] as? Bool ?? true
      
      Iaphub.buy(sku: sku, crossPlatformConflict: crossPlatformConflict, { (err, transaction) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, transaction?.getDictionary())
      })
   }
   
   /**
    *  Restore
    */
   private func restore(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      Iaphub.restore({ (err, response) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, response?.getDictionary())
      })
   }
   
   /**
    *  Get active products
    */
   private func getActiveProducts(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let includeSubscriptionStates = args["includeSubscriptionStates"] as? [String] ?? []
      
      Iaphub.getActiveProducts(includeSubscriptionStates: includeSubscriptionStates, { (err, products) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, products?.map({ (product) in product.getDictionary()}))
      })
   }
   
   /**
    *  Get products for sale
    */
   private func getProductsForSale(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      Iaphub.getProductsForSale({ (err, products) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, products?.map({ (product) in product.getDictionary()}))
      })
   }
   
   /**
    *  Get products (active and for sale)
    */
   private func getProducts(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let includeSubscriptionStates = args["includeSubscriptionStates"] as? [String] ?? []

      Iaphub.getProducts(includeSubscriptionStates: includeSubscriptionStates, { (err, products) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, products?.getDictionary())
      })
   }
   
   /**
    *  Get billing status
    */
   private func getBillingStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let status = Iaphub.getBillingStatus()
      
      self.resolve(result, status.getDictionary())
   }
   
   /**
    *  Present code redemption
    */
   private func presentCodeRedemptionSheet(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      Iaphub.presentCodeRedemptionSheet({ (err) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, nil)
      })
   }
   
   /**
    *  Show manage subscriptions page
    */
   private func showManageSubscriptions(_ call: FlutterMethodCall, result: @escaping FlutterResult, args: [String: Any]) {
      let sku = args["sku"] as? String

      Iaphub.showManageSubscriptions(sku: sku, { (err) in
         if let err = err {
            return self.reject(result, err)
         }
         self.resolve(result, nil)
      })
   }
   
   /***************************** PRIVATE ******************************/
   
   /**
    Create flutter error
    */
   func toJSON(_ data: Any) throws -> String {
      let json = try JSONSerialization.data(withJSONObject: data)
      
      guard let jsonStr = String(data: json, encoding: .utf8) else {
         throw FlutterLocalizedError("JSON serialization to string failed")
      }
      return jsonStr
   }
   
   /**
    Create flutter error
    */
   func createFlutterError(message: String, data: Dictionary<String, Any?>) -> FlutterError {
      do {
         let json = try self.toJSON(data)
         
         return FlutterError(code: "iaphub_error", message: message, details: json)
      }
      catch {
         return self.createUnexpectedError(subcode: "serialization_failed", message: "Error JSON serialization failed: \(error.localizedDescription)")
      }
   }
   
   /**
    Create unexpected error
    */
   func createUnexpectedError(subcode: String, message: String) -> FlutterError {
      let jsonStr = "{\"code\": \"unexpected\", \"subcode\": \"\(subcode)\", \"message\": \"\(message)\"}"
      
      return FlutterError(code: "iaphub_error", message: message, details: jsonStr)
   }
   
   /**
    Resolve
    */
   func resolve(_ result: @escaping FlutterResult, _ data: Any?) {
      guard let data = data else {
         return result(nil)
      }
      
      do {
         let json = try self.toJSON(data)
         
         result(json)
      }
      catch {
         result(self.createUnexpectedError(subcode: "serialization_failed", message: "Result JSON serialization failed: \(error.localizedDescription)"))
      }
   }
   
   /**
    Reject
    */
   func reject(_ result: @escaping FlutterResult, _ err: IHError) {
      result(self.createFlutterError(message: err.message, data: err.getDictionary()))
   }
   
   /**
    Reject
    */
   func reject(_ result: @escaping FlutterResult, code: String, subcode: String = "", message: String, params: Dictionary<String, Any> = [:]) {
      result(self.createFlutterError(message: message, data: ["code": code, "subcode": subcode, "message": message, "params": params]))
   }

   /***************************** EVENTS ******************************/
   
   /**
    Listen for user update event
    */
   public func didReceiveUserUpdate() {
      Self.channel?.invokeMethod("onUserUpdate", arguments: nil)
   }
   
   /**
    Listen for a deferred purchase event
    */
   public func didReceiveDeferredPurchase(transaction: IHReceiptTransaction) {
      guard let json = try? self.toJSON(transaction.getDictionary()) else { return }
      Self.channel?.invokeMethod("onDeferredPurchase", arguments: json)
   }
   
   /**
    Listen for error event
    */
   public func didReceiveError(err: IHError) {
      guard let json = try? self.toJSON(err.getDictionary()) else { return }
      Self.channel?.invokeMethod("onError", arguments: json)
   }
   
   /**
    Listen for buy request event
    */
   public func didReceiveBuyRequest(sku: String) {
      Self.channel?.invokeMethod("onBuyRequest", arguments: sku)
   }
   
   /**
    Listen for receipt event
    */
   public func didProcessReceipt(err: IHError?, receipt: IHReceipt?) {
      guard let json = try? self.toJSON(["err": err?.getDictionary(), "receipt": receipt?.getDictionary()]) else { return }
      Self.channel?.invokeMethod("onReceipt", arguments: json)
   }
   
}
