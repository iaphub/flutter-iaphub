package com.iaphub.iaphub_flutter

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull

import org.json.JSONObject
import com.google.gson.Gson

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.iaphub.Iaphub
import com.iaphub.IaphubError

/** IaphubFlutterPlugin */
class IaphubFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.channel = MethodChannel(flutterPluginBinding.binaryMessenger, "iaphub_flutter")
    this.channel.setMethodCallHandler(this)
    this.context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "start" -> this.start(call, result)
      "stop" -> this.stop(call, result)
      "setLang" -> this.setLang(call, result)
      "login" -> this.login(call, result)
      "getUserId" -> this.getUserId(call, result)
      "logout" -> this.logout(call, result)
      "setDeviceParams" -> this.setDeviceParams(call, result)
      "setUserTags" -> this.setUserTags(call, result)
      "buy" -> this.buy(call, result)
      "restore" -> this.restore(call, result)
      "getActiveProducts" -> this.getActiveProducts(call, result)
      "getProductsForSale" -> this.getProductsForSale(call, result)
      "getProducts" -> this.getProducts(call, result)
      "getBillingStatus" -> this.getBillingStatus(call, result)
      "showManageSubscriptions" -> this.showManageSubscriptions(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    this.channel.setMethodCallHandler(null)
  }

  /***************************** ACTIVITY METHODS ******************************/

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding.activity;
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity;
  }

  override fun onDetachedFromActivity() {
    this.activity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.activity = null
  }

  /***************************** IAPHUB METHODS ******************************/

  /**
   * Start IAPHUB
   */
  fun start(call: MethodCall, result: Result) {
    val appId = this.getString(call, "appId", "")
    val apiKey = this.getString(call, "apiKey", "")
    val userId = this.getStringOrNull(call, "userId")
    val allowAnonymousPurchase = this.getBoolean(call, "allowAnonymousPurchase", false)
    val enableDeferredPurchaseListener = this.getBoolean(call, "enableDeferredPurchaseListener", true)
    val environment = this.getString(call, "environment", "production")
    val lang = this.getString(call, "lang", "")
    val sdkVersion = this.getString(call, "sdkVersion", "")
    val extraSdk = this.getStringOrNull(call, "sdk")
    var sdk = "flutter"

    if (extraSdk != null) {
      sdk = "${sdk}/${extraSdk}"
    }
    // Start SDK
    Iaphub.start(
      context=this.context,
      appId=appId,
      apiKey=apiKey,
      userId=userId,
      allowAnonymousPurchase=allowAnonymousPurchase,
      enableDeferredPurchaseListener=enableDeferredPurchaseListener,
      environment=environment,
      lang=lang,
      sdk=sdk,
      sdkVersion=sdkVersion
    )
    // Register listeners
    Iaphub.setOnUserUpdateListener { ->
      this.channel.invokeMethod("onUserUpdate", null)
    }
    Iaphub.setOnDeferredPurchaseListener { transaction ->
      this.channel.invokeMethod("onDeferredPurchase", this.toJson(transaction.getData()))
    }
    Iaphub.setOnErrorListener { err ->
      this.channel.invokeMethod("onError", this.toJson(err.getData()))
    }
    Iaphub.setOnReceiptListener { err, receipt ->
      this.channel.invokeMethod("onReceipt", this.toJson(mapOf(
        "err" to if (err != null) err.getData() else null,
        "receipt" to if (receipt != null) receipt.getData() else null
      )))
    }
    // Resolve result
    this.resolve(null, result)
  }

  /**
   * Stop IAPHUB
   */
  fun stop(call: MethodCall, result: Result) {
    // Stop IAPHUB
    Iaphub.stop()
    // Resolve promise
    this.resolve(null, result)
  }

  /**
   * Login
   */
  fun login(call: MethodCall, result: Result) {
    val userId = this.getString(call, "userId", "")

    Iaphub.login(userId) { err ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else {
        this.resolve(null, result);
      }
    }
  }

  /**
   * Set lang
   */
  fun setLang(call: MethodCall, result: Result) {
    val lang = this.getString(call, "lang", "")
    val isValid = Iaphub.setLang(lang)
    
    result.success(if (isValid) "true" else "false")
  }

  /**
   * Get user id
   */
  fun getUserId(call: MethodCall, result: Result) {
    val userId = Iaphub.getUserId()

    if (userId == null) {
      this.rejectWithUnexpectedError("start_missing", "iaphub not started", result)
    }
    else {
      result.success(userId)
    }
  }

  /**
   * Logout
   */
  fun logout(call: MethodCall, result: Result) {
    // Logout
    Iaphub.logout()
    // Resolve result
    this.resolve(null, result)
  }

  /**
   * Set device params
   */
  fun setDeviceParams(call: MethodCall, result: Result) {
    val params = call.arguments as? Map<String, String>

    if (params == null) {
      return this.rejectWithUnexpectedError("params_invalid", "device params invalid", result)
    }

    Iaphub.setDeviceParams(params)
    this.resolve(null, result)
  }

  /**
   * Set user tags
   */
  fun setUserTags(call: MethodCall, result: Result) {
    val tags = call.arguments as? Map<String, String>

    if (tags == null) {
      return this.rejectWithUnexpectedError("tags_invalid", "tags invalid", result)
    }

    Iaphub.setUserTags(tags) { err ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else {
        this.resolve(null, result)
      }
    }
  }

  /**
   * Buy
   */
  fun buy(call: MethodCall, result: Result) {
    val activity = this.activity
    val sku = this.getString(call, "sku", "")
    val prorationMode = this.getStringOrNull(call, "prorationMode")
    val crossPlatformConflict = this.getBoolean(call, "crossPlatformConflict", true)

    if (activity == null) {
      this.rejectWithUnexpectedError("activity_null", "activity not found", result)
      return
    }
    Iaphub.buy(activity=activity, sku=sku, prorationMode=prorationMode, crossPlatformConflict=crossPlatformConflict, completion={ err, transaction ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else if (transaction == null) {
        this.rejectWithUnexpectedError("unexpected_parameter", "transaction returned by buy is null", result)
      }
      else {
        this.resolve(transaction.getData(), result)
      }
    })
  }

  /**
   * Restore
   */
  fun restore(call: MethodCall, result: Result) {
    Iaphub.restore { err, response ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else if (response == null) {
        this.rejectWithUnexpectedError("unexpected_parameter", "response returned by restore is null", result)
      }
      else {
        this.resolve(response.getData(), result)
      }
    }
  }

  /**
   * Get active products
   */
  fun getActiveProducts(call: MethodCall, result: Result) {
    val includeSubscriptionStates = this.getStringList(call, "includeSubscriptionStates", listOf())

    Iaphub.getActiveProducts(includeSubscriptionStates) { err, products ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else if (products == null) {
        this.rejectWithUnexpectedError("unexpected_parameter", "products returned by getActiveProducts is null", result)
      }
      else {
        this.resolve(products.map { product -> product.getData() }, result)
      }
    }
  }

  /**
   * Get products for sale
   */
  fun getProductsForSale(call: MethodCall, result: Result) {
    Iaphub.getProductsForSale { err, products ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else if (products == null) {
        this.rejectWithUnexpectedError("unexpected_parameter", "products returned by getProductsForSale is null", result)
      }
      else {
        this.resolve(products.map { product -> product.getData() }, result)
      }
    }
  }

  /**
   * Get products
   */
  fun getProducts(call: MethodCall, result: Result) {
    val includeSubscriptionStates = this.getStringList(call, "includeSubscriptionStates", listOf())

    Iaphub.getProducts(includeSubscriptionStates) { err, products ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else if (products == null) {
        this.rejectWithUnexpectedError("unexpected_parameter", "products returned by getActiveProducts is null", result)
      }
      else {
        this.resolve(products.getData(), result)
      }
    }
  }

  /**
   * Get billing status
   */
  fun getBillingStatus(call: MethodCall, result: Result) {
    val status = Iaphub.getBillingStatus()

    this.resolve(status.getData(), result)
  }

  /**
   * Show manage subscriptions
   */
  fun showManageSubscriptions(call: MethodCall, result: Result) {
    val sku = this.getStringOrNull(call, "sku")

    Iaphub.showManageSubscriptions(sku) { err ->
      if (err != null) {
        this.rejectWithError(err, result)
      }
      else {
        this.resolve(null, result)
      }
    }
  }

  /***************************** PRIVATE ******************************/

  /**
   * Convert object to JSON
   */
  private fun toJson(data: Any): String {
    val json = Gson().toJson(data)

    return json
  }

  /**
   * Reject result with error
   */
  private fun rejectWithError(err: IaphubError, result: Result) {
    val json = this.toJson(err.getData())

    result.error("iaphub_error", err.message, json)
  }

  /**
   * Reject result with unexpected error
   */
  private fun rejectWithUnexpectedError(subcode: String, message: String, result: Result) {
    val json = this.toJson(mapOf(
      "code" to "unexpected",
      "subcode" to subcode,
      "message" to message
    ))

    result.error("iaphub_error", message, json)
  }

  /**
   * Resolve
   */
  private fun resolve(data: Map<String, Any?>?, result: Result) {
    if (data == null) {
      return result.success(null)
    }
    else {
      val json = this.toJson(data)

      result.success(json);
    }
  }

  /**
   * Resolve
   */
  private fun resolve(data: List<Map<String, Any?>>, result: Result) {
    val json = this.toJson(data)

    result.success(json);
  }

  /**
   * Get string list
   */
  private fun getStringList(call: MethodCall, key: String, default: List<String>): List<String> {
    return try { call.argument<List<String>>(key) ?: default } catch (e: Exception) { default }
  }

  /**
   * Get string
   */
  private fun getString(call: MethodCall, key: String, default: String): String {
    return try { call.argument<String>(key) ?: default } catch (e: Exception) { default }
  }

  /**
   * Get string or null value
   */
  private fun getStringOrNull(call: MethodCall, key: String): String? {
    return try { call.argument<String>(key) } catch (e: Exception) { null }
  }

  /**
   * Get boolean
   */
  private fun getBoolean(call: MethodCall, key: String, default: Boolean = false): Boolean {
    return try { call.argument<Boolean>(key) ?: default } catch (e: Exception) { default }
  }

}
