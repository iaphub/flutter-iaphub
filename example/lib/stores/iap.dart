import 'package:mobx/mobx.dart';
import 'package:iaphub_flutter/iaphub_flutter.dart';
import './index.dart';

part 'iap.g.dart';

class IapStore extends _IapStore with _$IapStore {}

abstract class _IapStore with Store {
  @observable
  bool isInitialized = false;

  @observable
  String? skuProcessing;

  @observable
  List<IaphubProduct> productsForSale = [];

  @observable
  List<IaphubActiveProduct> activeProducts = [];

  @observable
  IaphubBillingStatus? billingStatus;

  @action
  init() async {
    // Start iaphub
    await Iaphub.start(
        // The app id is available on the settings page of your app
        appId: "5e4890f6c61fc971cf46db4d",
        // The (client) api key is available on the settings page of your app
        apiKey: "SDp7aY220RtzZrsvRpp4BGFm6qZqNkNf");
    // Iaphub is now initialized and ready to use
    isInitialized = true;
    // Listen to user updates and refresh productsForSale/activeProducts
    Iaphub.addEventListener('onUserUpdate', () {
      refreshProducts();
    });
    Iaphub.addEventListener('onDeferredPurchase', (transaction) {
      // Triggered when a deferred purchase is detected
    });
    Iaphub.addEventListener('onError', (err) {
      // Triggered when an error is detected
    });
    Iaphub.addEventListener('onReceipt', (receipt) {
      // Triggered when a receipt is detected
    });
    Iaphub.addEventListener('onBuyRequest', (opts) {
      // Triggered when a buy request is detected
    });
  }

  login(String userId) async {
    await Iaphub.login(userId);
  }

  setUserTags(Map<String, String> tags) async {
    await Iaphub.setUserTags(tags);
  }

  setDeviceParams(Map<String, String> params) async {
    await Iaphub.setDeviceParams(params);
  }

  logout() async {
    await Iaphub.logout();
  }

  // Refresh products
  @action
  refreshProducts() async {
    // Refresh products
    var products = await Iaphub.getProducts();
    activeProducts = products.activeProducts;
    productsForSale = products.productsForSale;
    // Resfresh billing status
    billingStatus = await Iaphub.getBillingStatus();
  }

  @action
  buy(String productSku) async {
    try {
      skuProcessing = productSku;
      var transaction = await Iaphub.buy(productSku);
      skuProcessing = null;
      /*
       * The purchase has been successful but we need to check that the webhook to our server was successful as well
       * If the webhook request failed, IAPHUB will send you an alert and retry again in 1 minute, 10 minutes, 1 hour and 24 hours.
       * You can retry the webhook directly from the dashboard as well
       */
      if (transaction.webhookStatus == "failed") {
        appStore.openAlert(
            "Your purchase was successful but we need some more time to validate it, should arrive soon! Otherwise contact the support (support@myapp.com)");
      }
      // Everything was successful! Yay!
      else {
        appStore.openAlert("Your purchase has been processed successfully!");
      }
    } on IaphubError catch (err) {
      skuProcessing = null;

      var errors = {
        // Couldn't buy product because it has been bought in the past but hasn't been consumed (restore needed)
        "product_already_owned":
            "Product already owned, please restore your purchases in order to fix that issue",
        // The payment has been deferred (its final status is pending external action such as 'Ask to Buy')
        "deferred_payment":
            "Purchase awaiting approval, your purchase has been processed but is awaiting approval",
        // The billing is unavailable (An iPhone can be restricted from accessing the Apple App Store)
        "billing_unavailable": "In-app purchase not allowed",
        // The remote server couldn't be reached properly
        "network_error":
            "Network error, please try to restore your purchases later (Button in the settings) or contact the support (support@myapp.com)",
        // The receipt has been processed on IAPHUB but something went wrong
        // It is probably because of an issue with the configuration of your app or a call to the Itunes/GooglePlay API that failed
        // IAPHUB will automatically retry to process the receipt if possible (depends on the error)
        "receipt_failed":
            "We're having trouble validating your transaction, give us some time, we'll retry to validate your transaction ASAP",
        // The user has already an active subscription on a different platform (android or ios)
        // This security has been implemented to prevent a user from ending up with two subscriptions of different platforms
        // You can disable the security by providing the 'crossPlatformConflict' parameter to the buy method (Iaphub.buy(sku, {crossPlatformConflict: false}))
        "cross_platform_conflict":
            "It seems like you already have a subscription on a different platform, please use the same platform to change your subscription or wait for your current subscription to expire",
        // The transaction is successful but the product belongs to a different user
        // You should ask the user to use the account with which he originally bought the product or ask him to restore its purchases in order to transfer the previous purchases to the new account
        "user_conflict":
            "Product owned by a different user, please use the account with which you originally bought the product or restore your purchases",
        // Unknown
        "unexpected":
            "We were not able to process your purchase, please try again later or contact the support (support@myapp.com)"
      };
      var errorsToIgnore = ["user_cancelled", "product_already_purchased"];
      var errorMessage = errors[err.code];

      if (errorMessage == null && !errorsToIgnore.contains(err.code)) {
        errorMessage = errors["unexpected"];
      }
      if (errorMessage != null) {
        appStore.openAlert(errorMessage);
      }
    }
  }

  @action
  restore() async {
    await Iaphub.restore();
    appStore.openAlert("Purchases restored");
  }

  @action
  showManageSubscriptions() async {
    await Iaphub.showManageSubscriptions();
  }

  @action
  presentCodeRedemptionSheet() async {
    await Iaphub.presentCodeRedemptionSheet();
  }
}
