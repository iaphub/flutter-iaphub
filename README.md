<a href="https://www.iaphub.com" title="IAPHUB">
  <img width=882px src="https://www.iaphub.com/img/github/github-flutter-ad.png" alt="IAPHUB">
</a>
<br/>
<br/>

We're making in-app purchases EASY.<br/>
Stop wasting time & resources to reinvent the wheel.<br/>
@ [IAPHUB](https://www.iaphub.com) we developed all the tools you need to sell in-app purchases & subscriptions, manage your customers and grow your revenue. 🚀
<br/>

## Getting started

Implementing In-app purchases in your app should be a piece of cake!<br/>

1. Create an account on [IAPHUB](https://www.iaphub.com)

2. Add `iaphub_flutter` as a dependency in your pubspec.yaml file
```yaml
dependencies:
  iaphub_flutter: ^1.0.0
```
You can also run the following command
```bash
flutter pub add iaphub_flutter
```

3. Read our complete guide to [set up your app](https://www.iaphub.com/docs/getting-started/set-up-app/).

## Start
Call the `start` method in order to initialize IAPHUB.<br/><br/>
ℹ️ It should be called as soon as possible when starting your app.

```js
  await Iaphub.start(
    // The app id is available on the settings page of your app
    appId: "5e4890f6c61fc971cf46db4d",
    // The (client) api key is available on the settings page of your app
    apiKey: "SDp7aY220RtzZrsvRpp4BGFm6qZqNkNf",
    // Optional, ff you want to allow purchases when the user has an anonymous user id
    // If you're listenning to IAPHUB webhooks your implementation must support users with anonymous user ids
    // This option is disabled by default, when disabled the buy method will return an error when the user isn't logged in
    allowAnonymousPurchase: true
  );
```

## Events
Call the `addEventListener` method to listen to an event and `removeEventListener` to stop listening to an event.<br/>

#### onUserUpdate - Event triggered when the user products have been updated
```js
  // Listen to the user update event in order to know when the activeProducts/productsForSale are updated
  var listener = Iaphub.addEventListener('onUserUpdate', () {
    // TODO here: Refresh the state of your products in order to refresh the screen
    // You can use the getActiveProducts/getProductsForSale methods to get the updated products
  });
  // You can also unlisten the event
  Iaphub.removeEventListener(listener);
```

#### onDeferredPurchase - Event triggered when a purchase is processed 'outside' of the buy method
```js
  // This event could be triggered:
  // - After a purchase is made outside the app (by redeeming a promo code on the store by example)
  // - After a deferred payment (when the error code 'deferred_payment' is returned by the buy method)
  // - After a payment fails because it couldn't be validated by IAPHUB (and succeeds later)
  var listener = Iaphub.addEventListener('onDeferredPurchase', (transaction) {
    
  });
  // You can also unlisten the event
  Iaphub.removeEventListener(listener);
```

#### onBuyRequest - Event triggered when a purchase intent is made from outside the app (like a promoted In-App purchase)
```js
  // Add listener
  var listener = Iaphub.addEventListener('onBuyRequest', (sku) {
    // If you want to allow/disallow a purchase intent (to wait until the user is logged in for example) you can implement this method
    // You'll have to call the buy method whenever you're ready
    // Also note you'll have a callback to know when the transaction is done (you woudn't otherwise)
    var transaction = await Iaphub.buy(sku);
    console.log("Purchase done: ", transaction);
  });
  // Remove listener
  Iaphub.removeEventListener(listener);
```

#### onError - Event triggered when IAPHUB has detected an error
```js
  // Add listener
  var listener = Iaphub.addEventListener('onError', (err) {
    // You'll catch any error here (even errors thrown by IAPHUB methods)
    console.log("Error: ", err.message);
  });
  // Remove listener
  Iaphub.removeEventListener(listener);
```

#### onReceipt - Event triggered after a receipt has been processed
```js
  // Add listener
  var listener = Iaphub.addEventListener('onReceipt', (data) {
    console.log("Receipt err: ", data.err);
    console.log("Receipt data: ", err.receipt);
  });
  // Remove listener
  Iaphub.removeEventListener(listener);
```

ℹ️ You can also remove all the listeners by using the method `removeAllListeners()`

## Login
Call the `login` method to authenticate a user.<br/>

⚠ When a user isn't logged he's considered *anonymous*, we'll generate automatically a anonymous user id (prefixed with 'a:')

⚠ You should provide an id that is non-guessable and isn't public. (Email not allowed)

⚠ The user will be reset, `setOnUserUpdateListener` will only be called until after the user has been loaded first (using getProductsForSale/getActiveProducts).<br/>

```js
await Iaphub.login("1e5494930c48ed07aa275fd2");
```

## Get user ID
Call the `getUserId` method to get the user id of the logged user.<br/>
If no user is logged the anonymous user id will be returned (prefixed with 'a:').

```js
var userId = await Iaphub.getUserId()
```

## Logout
Call the `logout` method to log the user out.<br/>
The user will switch back to his anonymous user id (prefixed with 'a:').<br/>

⚠ The user will be reset, `setOnUserUpdateListener` will only be called until after the user has been loaded first (using getProductsForSale/getActiveProducts).<br/>

```js
await Iaphub.logout()
```

## Set user tags
Call the `setUserTags` method to update the user tags.<br/>
User tags will appear on the user page of the IAPHUB dashboard.<br/>
When using IAPHUB's smart listings, you'll be able to return different products depending on the user tags.

```js
// To set a tag
await Iaphub.setUserTags({"status": "vip"});
// To clear the user tags
await Iaphub.setUserTags({"status": ""});
```

A few details:
  - A tag must be created on the IAPHUB dashboard (otherwise the method will throw an error)
  - When creating a tag on the IAPHUB dashboard you must check the option to allow editing the tag from the client (otherwise you'll only be able to edit the tag using the [IAPHUB API](https://www.iaphub.com/docs/api/post-user) from your server)
  - A tag key is limited to 32 characters
  - A tag value is limited to 64 characters

## Set device params
Call the `setDeviceParams` method to set parameters for the device<br/>
When using IAPHUB's smart listings, you'll be able to return different products depending on the device params.

```js
// For instance you can provide the app version on app launch
// Useful to return a product only supported in a new version
await Iaphub.setDeviceParams({"appVersion": "1.2.0"});
// To clear the device params
await Iaphub.setDeviceParams({});
```

A few details:
  - The params are not saved on the device, they won't persist if the app is restarted
  - The params are not saved on IAPHUB, they are just provided to the API when fetching the products for sale
  - A param key limited to 32 characters and must be a valid key (``^[a-zA-Z_]*$``)
  - A param value limited to 32 characters
  - You can provide up to 5 params

## Get products for sale
Call the ``getProductsForSale`` method to get the user's products for sale<br/>
You should use this method when displaying the page with the list of your products for sale.

⚠ If the request fails because of a network issue, the method returns the latest request in cache (if available, otherwise an error is thrown).

⚠ If a product is returned by the [API](https://www.iaphub.com/docs/api/get-user/) but the sku cannot be loaded, it'll be filtered from the list and an error message will be displayed in the console

⚠ If you have multiple Android offers, the oldest (first one you've created) will be used by default. We've decided to not support multiple Android offers in order to have a common system with iOS. To have a different offer simply create a new product, you can do pretty much everything with [smart listings](https://www.iaphub.com/docs/resources/smart-listing).

```js
var products = await Iaphub.getProductsForSale();

print(products);
[
  {
    id: "5e5198930c48ed07aa275fd9",
    type: "renewable_subscription",
    sku: "membership2_tier10",
    group: "3e5198930c48ed07aa275fd8",
    groupName: "subscription_group_1",
    localizedTitle: "Membership",
    localizedDescription: "Become a member of the community",
    localizedPrice: "$9.99",
    price: 9.99,
    currency: "USD",
    subscriptionDuration: "P1M",
    subscriptionIntroPhases: [
      {
        type: "trial",
        price: 0,
        currency: "USD",
        localizedPrice: "FREE",
        cycleDuration: "P1M",
        cycleCount: 1,
        payment: "upfront"
      },
      {
        type: "intro",
        price: 4.99,
        currency: "USD",
        localizedPrice: "$4.99",
        cycleDuration: "P1M",
        cycleCount: 3,
        payment: "as_you_go"
      }
    ]
  },
  {
    id: "5e5198930c48ed07aa275fd9",
    type: "consumable",
    sku: "pack10_tier15",
    localizedTitle: "Pack 10",
    localizedDescription: "Pack of 10 coins",
    localizedPrice: "$14.99",
    price: 14.99,
    currency: "USD"
  }
]
```

## Get active products
If you're relying on IAPHUB on the client side (instead of using your server with webhooks) to detect if the user has active products (auto-renewable subscriptions, non-renewing subscriptions or non-consumables), you should use the `getActiveProducts` method.<br/>

⚠ If the request fails because of a network issue, the method returns the latest request in cache (if available with no expired subscription, otherwise an error is thrown).

⚠ If an active product is returned by the API but the sku cannot be loaded, the product will be returned but only with the properties coming from the [API](https://www.iaphub.com/docs/api/get-user/) (The price, title, description.... properties won't be returned).

#### Subscription state

Value | Description |
| :------------ |:---------------
| active | The subscription is active
| grace_period | The subscription is in the grace period, the user should still access the features offered by your subscription
| retry_period | The subscription is in the retry period, you must restrict the access to the features offered by your subscription and display a message asking for the user to update its payment informations.
| paused | The subscription is paused (Android only) and will automatically resume at a later date (`autoResumeDate` property), you must restrict the access to the features offered by your subscription.

By default only subscriptions with an `active` or `grace_period` state are returned by the `getActiveProducts()` method because you must restrict the access to the features offered by your subscription on a `retry_period` or `paused` state.<br/>
<br/>
If you're looking to display a message when a user has a subscription on a `retry_period` or `paused` state, you can use the `includeSubscriptionStates` option.
```js
  var allActiveProducts = await Iaphub.getActiveProducts(includeSubscriptionStates: ['retry_period', 'paused']);
```

## Get all products
You can also get the products for sale and active products using one method `getProducts()`

```js
  var products = await Iaphub.getProducts();
  print("Products for sale: ${products.productsForSale}");
  print("Active products: ${products.activeProducts}");
```

## Get billing status
The `getBillingStatus` method will return useful informations if you have an issue with the products returned by the `getProducts` or `getProductsForSale` methods (for instance if no products for sale were returned).
```js
  var status = await Iaphub.getBillingStatus();

  // You should display an appropriate message if the billing is unavailable
  if (status.error?.code == "billing_unavailable") {
    if (status.error?.subcode == "play_store_outdated") {
      // Display a message saying that the Play Store app on the user's device is out of date, it must be updated
    }
    else {
      // Display a message saying that the in-app billing isn't available on the device
    }
  }
  // Check the products that were filtered from the products for sale
  if (status.filteredProductIds.length) {
    // The product ids in the array were not returned by iTunes/GooglePlay
  }
```

## Buy a product
Call the ``buy`` method to buy a product<br/><br/>
ℹ️ The method needs the product sku that you would get from one of the products of `getProductsForSale()`.<br/>
ℹ️ The method will process a purchase as a subscription replace if you currently have an active subscription and you buy a subscription of the same group (product group created on IAPHUB).<br/>

```js
try {
  var transaction = await Iaphub.buy("pack10_tier15");
  print(transaction);
  {
    id: "2e5198930c48ed07aa275fd3",
    type: "consumable",
    sku: "pack10_tier15",
    purchase: "4e5198930c48ed07aa275fd2",
    purchaseDate: "2020-03-11T00:42:27.000Z",
    webhookStatus: "success",
    group: "3e5198930c48ed07aa275fd8",
    groupName: "pack",
    localizedTitle: "Pack 10",
    localizedDescription: "Pack of 10 coins",
    localizedPrice: "$14.99",
    price: 14.99,
    currency: "USD"
  }

  /*
   * The purchase has been successful but we need to check that the webhook to our server was successful as well
   * If the webhook request failed, IAPHUB will send you an alert and retry again in 1 minute, 10 minutes, 1 hour and 24 hours.
   * You can retry the webhook directly from the dashboard as well
   */
  if (transaction.webhookStatus == "failed") {
    showAlert(
      "Purchase delayed",
      "Your purchase was successful but we need some more time to validate it, should arrive soon! Otherwise contact the support (support@myapp.com)"
    );
  }
  // Everything was successful! Yay!
  else {
    showAlert(
      "Purchase successful",
      "Your purchase has been processed successfully!"
    );
  }
}
catch (err) {
  var errors = {
    // Couldn't buy product because it has been bought in the past but hasn't been consumed (restore needed)
    "product_already_owned": "Product already owned, please restore your purchases in order to fix that issue",
    // The payment has been deferred (its final status is pending external action such as 'Ask to Buy')
    "deferred_payment": "Purchase awaiting approval, your purchase has been processed but is awaiting approval",
    // The billing is unavailable (An iPhone can be restricted from accessing the Apple App Store)
    "billing_unavailable": "In-app purchase not allowed",
    // The remote server couldn't be reached properly
    "network_error": "Network error, please try to restore your purchases later (Button in the settings) or contact the support (support@myapp.com)",
    /*
     * The receipt has been processed on IAPHUB but something went wrong
     * It is probably because of an issue with the configuration of your app or a call to the Itunes/GooglePlay API that failed
     * IAPHUB will automatically retry to process the receipt if possible (depends on the error)
     */
    "receipt_failed": "We're having trouble validating your transaction, give us some time, we'll retry to validate your transaction ASAP",
    /*
     * The user has already an active subscription on a different platform (android or ios)
     * This security has been implemented to prevent a user from ending up with two subscriptions of different platforms
     * You can disable the security by providing the 'crossPlatformConflict' parameter to the buy method (Iaphub.buy(sku, {crossPlatformConflict: false}))
     */
    "cross_platform_conflict": "It seems like you already have a subscription on a different platform, please use the same platform to change your subscription or wait for your current subscription to expire",
    /*
     * The transaction is successful but the product belongs to a different user
     * You should ask the user to use the account with which he originally bought the product or ask him to restore its purchases in order to transfer the previous purchases to the new account
     */
    "user_conflict": "Product owned by a different user, please use the account with which you originally bought the product or restore your purchases",
    // Unknown
    "unexpected": "We were not able to process your purchase, please try again later or contact the support (support@myapp.com)"
  };
  var errorsToIgnore = ["user_cancelled", "product_already_purchased"];
  var errorMessage = errors[err.code];

  if (!errorMessage && errorsToIgnore.indexOf(err.code) == -1) {
    errorMessage = errors["unexpected"];
  }
  if (errorMessage) {
    showAlert("Error", errorMessage);
  }
}
```

#### Proration mode (Android only)

You can specify the proration mode when replacing a subscription.

```js
var transaction = await Iaphub.buy("membership_tier1", prorationMode: 'immediate_and_charge_prorated_price');
```

Value | Description |
| :------------ |:---------------
| immediate_with_time_proration | The replacement takes effect immediately, the remaining time will be prorated for the new subscription. **(default)**
| immediate_and_charge_prorated_price | The replacement takes effect immediately, the price of the previous subscription will be prorated (partial refund).
| immediate_without_proration | The replacement takes effect immediately with no extra charge, the new price will be charged on next recurrence time.
| deferred | The replacement takes effect when the current subscription expires

## Restore user purchases
Call the ``restore`` method to restore the user purchases<br/><br/>
ℹ️ You must display a button somewhere in your app in order to allow the user to restore its purchases.<br/>

```js
var response = await Iaphub.restore();
// New purchases
print('New purchases: ${response.newPurchases}');
// Extisting active products transferred to the user
print('Transferred active products: ${response.transferredActiveProducts}');
```

## Show manage subscriptions
Call the ``showManageSubscriptions`` to display the GooglePlay/AppStore page to manage the subscriptions.<br/><br/>

```js
await Iaphub.showManageSubscriptions();
```

You can also specify the sku of an active subscription and you'll be redirected to the specified susbcription (Android only).

```js
await Iaphub.showManageSubscriptions(sku: "subscription1");
```

## Present code redemption sheet (iOS only)
Call the ``presentCodeRedemptionSheet`` to display a sheet that enable users to redeem subscription offer codes that you configure in App Store Connect<br/><br/>

```js
await Iaphub.presentCodeRedemptionSheet();
```

## Properties

### IaphubProduct
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| id | `String` | Product id (From IAPHUB) |
| type | `String` | Product type (Possible values: 'consumable', 'non_consumable', 'subscription', 'renewable_subscription') |
| sku | `String` | Product sku (Ex: "membership_tier1") |
| price | `double` | Price amount (Ex: 12.99) |
| currency | `String?` | Price currency code (Ex: "USD") |
| localizedPrice | `String?` | Localized price (Ex: "$12.99") |
| localizedTitle | `String?` | Product title (Ex: "Membership") |
| localizedDescription | `String?` | Product description (Ex: "Join the community with a membership") |
| group | `String?` | ⚠ Only available if the product as a group<br>Group id (From IAPHUB) |
| groupName | `String?` | ⚠ Only available if the product as a group<br>Name of the product group created on IAPHUB (Ex: "premium") |
| subscriptionDuration | `String?` | ⚠ Only available for a subscription<br> Duration of the subscription cycle specified in the ISO 8601 format (Possible values: 'P1W', 'P1M', 'P3M', 'P6M', 'P1Y') |
| subscriptionIntroPhases | `List<IaphubSubscriptionIntroPhase>?` | ⚠ Only available for a subscription<br> Ordered list of the subscription intro phases (intro price, free trial) |

### IaphubSubscriptionIntroPhase
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| type | `String` | Introductory type (Possible values: 'trial', 'intro')  |
| price | `double` | Introductory price amount (Ex: 2.99) |
| currency | `String` | Introductory price currency code (Ex: "USD") |
| localizedPrice | `String` | Localized introductory price (Ex: "$2.99") |
| cycleCount | `int` | Number of cycles in the introductory offer |
| cycleDuration | `String` | Duration of a introductory cycle specified in the ISO 8601 format (Possible values: 'P1W', 'P1M', 'P3M', 'P6M', 'P1Y') |

### IaphubActiveProduct (inherit from IaphubProduct)
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| purchase | `String?` | Purchase id (From IAPHUB) |
| purchaseDate | `String?` | Purchase date |
| platform | `String?` | Platform of the purchase (Possible values: 'ios', 'android') |
| isPromo | `bool` | True if purchased using a promo code |
| promoCode | `String?` | Promo code (Android: only available for subscriptions vanity codes, not available for one time codes) (iOS: the value is the offer reference name) |
| expirationDate | `String?` | Subscription expiration date |
| originalPurchase | `String?` | Subscription original purchase id |
| isSubscriptionRenewable | `bool` | True if the auto-renewal is enabled |
| isFamilyShare | `bool` | True if the subscription is shared by a family member (iOS subscriptions only) |
| subscriptionRenewalProduct | `String?` | Subscription product id of the next renewal (only defined if different than the current product) |
| subscriptionRenewalProductSku | `String?` | Subscription product sku of the next renewal |
| subscriptionState | `String?` | State of the subscription<br>(Possible values: 'active', 'grace_period', 'retry_period', 'paused') |
| subscriptionPeriodType | `String?` | Current phase type of the subscription<br>(Possible values: 'normal', 'trial', 'intro') |
| androidToken | `String?` | ⚠ Only available for an android purchase<br>Android purchase token of the transaction |

### IaphubTransaction (inherit from IaphubActiveProduct)
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| webhookStatus | `String?` | Webhook status (Possible values: 'success', 'failed', 'disabled') |
| user | `String?` | User id (From IAPHUB) |

### IaphubProducts
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| productsForSale | `List<IaphubProduct>` | Products for sale |
| activeProducts | `List<IaphubActiveProduct>` | Active products |

### IaphubRestoreResponse
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| newPurchases | `List<IaphubTransaction>` | New purchases processed during the restore |
| transferredActiveProducts | `List<IaphubActiveProduct>` | Active products transferred (from another user) during the restore |

### IaphubError
| Prop  | Type | Description |
| :------------ |:---------------:| :-----|
| message | `String` | Error message |
| code | `String` | Error code |
| subcode | `String?` | Error code |
| params | `Map<String, dynamic>?` | Error params |

## Full example

You should check out the [Example app](https://github.com/iaphub/flutter-iaphub/tree/master/example).
<br/>