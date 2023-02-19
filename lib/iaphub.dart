import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import './config.dart';
import './models/transaction.dart';
import './models/restore_response.dart';
import './models/product.dart';
import './models/active_product.dart';
import './models/products.dart';
import './models/billing_status.dart';
import './models/error.dart';

class Iaphub {
  static const _channel = MethodChannel('iaphub_flutter');

  static Map<String, List<Function>> _listeners = {};

  /// Start Iaphub
  static Future<void> start(
      {String appId = "",
      String apiKey = "",
      String? userId,
      bool allowAnonymousPurchase = false,
      String environment = 'production'}) async {
    // Clear listeners
    removeAllListeners();
    // Add channel call handler
    _channel.setMethodCallHandler(_invokeListener);
    // Invoke start
    const sdkVersion = IaphubConfig.version;
    await _invokeMethod('start', {
      "appId": appId,
      "apiKey": apiKey,
      "userId": userId,
      "allowAnonymousPurchase": allowAnonymousPurchase,
      "environment": environment,
      "sdkVersion": sdkVersion
    });
    // Display product missing error
    addEventListener("onError", (err) {
      if (err.code == "unexpected" &&
          err.subcode == "product_missing_from_store") {
        debugPrint(err.message);
      }
    });
  }

  /// Add event listeners
  static Function addEventListener(String eventName, Function callback) {
    if (_listeners[eventName] == null) {
      _listeners[eventName] = [];
    }
    _listeners[eventName]?.add(callback);
    return callback;
  }

  /// Remove event listener
  static void removeEventListener(Function callback) {
    _listeners.forEach((eventName, events) {
      int index = events.indexOf(callback);

      if (index != -1) {
        events.removeAt(index);
      }
    });
  }

  /// Remove all event listeners
  static void removeAllListeners() {
    _listeners = {};
  }

  /// Stop Iaphub
  static Future<void> stop() async {
    await _invokeMethod('stop', {});
  }

  /// Log in user
  static Future<void> login(String userId) async {
    await _invokeMethod('login', {"userId": userId});
  }

  /// Get user id
  static Future<String> getUserId() async {
    return await _invokeMethodAndParseString('getUserId', {});
  }

  /// Log out user
  static Future<void> logout() async {
    await _invokeMethod('logout', {});
  }

  /// Set device params
  static Future<void> setDeviceParams(Map<String, String> params) async {
    await _invokeMethod('setDeviceParams', params);
  }

  /// Set user tags
  static Future<void> setUserTags(Map<String, String> tags) async {
    await _invokeMethod('setUserTags', tags);
  }

  /// Buy product
  static Future<IaphubTransaction> buy(String sku,
      {bool crossPlatformConflict = true, String? prorationMode}) async {
    final data =
        await _invokeMethodAndParseResult<Map<String, dynamic>>('buy', {
      "sku": sku,
      "crossPlatformConflict": crossPlatformConflict,
      "prorationMode": prorationMode
    });

    return IaphubTransaction.fromJson(data);
  }

  /// Restore purchases
  static Future<IaphubRestoreResponse> restore() async {
    final data =
        await _invokeMethodAndParseResult<Map<String, dynamic>>('restore', {});

    return IaphubRestoreResponse.fromJson(data);
  }

  /// Get active products
  static Future<List<IaphubActiveProduct>> getActiveProducts(
      {List<String> includeSubscriptionStates = const []}) async {
    final data = await _invokeMethodAndParseResult<List<Map<String, dynamic>>>(
        'getActiveProducts',
        {"includeSubscriptionStates": includeSubscriptionStates});

    return data.map((item) => IaphubActiveProduct.fromJson(item)).toList();
  }

  /// Get products for sale
  static Future<List<IaphubProduct>> getProductsForSale() async {
    final data = await _invokeMethodAndParseResult<List<Map<String, dynamic>>>(
        'getProductsForSale', {});

    return data.map((item) => IaphubProduct.fromJson(item)).toList();
  }

  /// Get products
  static Future<IaphubProducts> getProducts(
      {List<String> includeSubscriptionStates = const []}) async {
    final data = await _invokeMethodAndParseResult<Map<String, dynamic>>(
        'getProducts',
        {"includeSubscriptionStates": includeSubscriptionStates});

    return IaphubProducts.fromJson(data);
  }

  /// Get billing status
  static Future<IaphubBillingStatus> getBillingStatus() async {
    final data = await _invokeMethodAndParseResult<Map<String, dynamic>>(
        'getBillingStatus', {});

    return IaphubBillingStatus.fromJson(data);
  }

  /// Present code redemption (iOS only)
  static Future<void> presentCodeRedemptionSheet() async {
    await _invokeMethod('presentCodeRedemptionSheet', {});
  }

  /// Show manage subscriptions page
  static Future<void> showManageSubscriptions({String? sku}) async {
    await _invokeMethod('showManageSubscriptions', {"sku": sku});
  }

  // PRIVATE

  static Future<T> _invokeMethodAndParseResult<T>(String methodName,
      [dynamic args]) async {
    try {
      final data = await _channel.invokeMethod<String>(methodName, args);

      return jsonDecode(data as String);
    } on PlatformException catch (err) {
      throw err.details != null
          ? IaphubError.fromJson(jsonDecode(err.details))
          : err;
    }
  }

  static Future<String> _invokeMethodAndParseString(String methodName,
      [dynamic args]) async {
    try {
      final data = await _channel.invokeMethod<String>(methodName, args);

      return data as String;
    } on PlatformException catch (err) {
      throw err.details != null
          ? IaphubError.fromJson(jsonDecode(err.details))
          : err;
    }
  }

  static Future<void> _invokeMethod(String methodName, [dynamic args]) async {
    try {
      await _channel.invokeMethod<void>(methodName, args);
    } on PlatformException catch (err) {
      throw err.details != null
          ? IaphubError.fromJson(jsonDecode(err.details))
          : err;
    }
  }

  static Future<dynamic> _invokeListener(MethodCall call) async {
    executeListener(callback) {
      if (call.method == "onUserUpdate") {
        callback();
      } else if (call.method == "onDeferredPurchase") {
        callback(
            IaphubTransaction.fromJson(jsonDecode(call.arguments as String)));
      } else if (call.method == "onError") {
        callback(IaphubError.fromJson(jsonDecode(call.arguments as String)));
      } else if (call.method == "onBuyRequest") {
        callback(call.arguments as String);
      } else if (call.method == "onReceipt") {
        callback(jsonDecode(call.arguments as String));
      }
    }

    _listeners[call.method]?.forEach(executeListener);
  }
}
