// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IapStore on _IapStore, Store {
  late final _$isInitializedAtom =
      Atom(name: '_IapStore.isInitialized', context: context);

  @override
  bool get isInitialized {
    _$isInitializedAtom.reportRead();
    return super.isInitialized;
  }

  @override
  set isInitialized(bool value) {
    _$isInitializedAtom.reportWrite(value, super.isInitialized, () {
      super.isInitialized = value;
    });
  }

  late final _$skuProcessingAtom =
      Atom(name: '_IapStore.skuProcessing', context: context);

  @override
  String? get skuProcessing {
    _$skuProcessingAtom.reportRead();
    return super.skuProcessing;
  }

  @override
  set skuProcessing(String? value) {
    _$skuProcessingAtom.reportWrite(value, super.skuProcessing, () {
      super.skuProcessing = value;
    });
  }

  late final _$productsForSaleAtom =
      Atom(name: '_IapStore.productsForSale', context: context);

  @override
  List<IaphubProduct> get productsForSale {
    _$productsForSaleAtom.reportRead();
    return super.productsForSale;
  }

  @override
  set productsForSale(List<IaphubProduct> value) {
    _$productsForSaleAtom.reportWrite(value, super.productsForSale, () {
      super.productsForSale = value;
    });
  }

  late final _$activeProductsAtom =
      Atom(name: '_IapStore.activeProducts', context: context);

  @override
  List<IaphubActiveProduct> get activeProducts {
    _$activeProductsAtom.reportRead();
    return super.activeProducts;
  }

  @override
  set activeProducts(List<IaphubActiveProduct> value) {
    _$activeProductsAtom.reportWrite(value, super.activeProducts, () {
      super.activeProducts = value;
    });
  }

  late final _$billingStatusAtom =
      Atom(name: '_IapStore.billingStatus', context: context);

  @override
  IaphubBillingStatus? get billingStatus {
    _$billingStatusAtom.reportRead();
    return super.billingStatus;
  }

  @override
  set billingStatus(IaphubBillingStatus? value) {
    _$billingStatusAtom.reportWrite(value, super.billingStatus, () {
      super.billingStatus = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_IapStore.init', context: context);

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$refreshProductsAsyncAction =
      AsyncAction('_IapStore.refreshProducts', context: context);

  @override
  Future refreshProducts() {
    return _$refreshProductsAsyncAction.run(() => super.refreshProducts());
  }

  late final _$buyAsyncAction = AsyncAction('_IapStore.buy', context: context);

  @override
  Future buy(String productSku) {
    return _$buyAsyncAction.run(() => super.buy(productSku));
  }

  late final _$restoreAsyncAction =
      AsyncAction('_IapStore.restore', context: context);

  @override
  Future restore() {
    return _$restoreAsyncAction.run(() => super.restore());
  }

  late final _$showManageSubscriptionsAsyncAction =
      AsyncAction('_IapStore.showManageSubscriptions', context: context);

  @override
  Future showManageSubscriptions() {
    return _$showManageSubscriptionsAsyncAction
        .run(() => super.showManageSubscriptions());
  }

  late final _$presentCodeRedemptionSheetAsyncAction =
      AsyncAction('_IapStore.presentCodeRedemptionSheet', context: context);

  @override
  Future presentCodeRedemptionSheet() {
    return _$presentCodeRedemptionSheetAsyncAction
        .run(() => super.presentCodeRedemptionSheet());
  }

  @override
  String toString() {
    return '''
isInitialized: ${isInitialized},
skuProcessing: ${skuProcessing},
productsForSale: ${productsForSale},
activeProducts: ${activeProducts},
billingStatus: ${billingStatus}
    ''';
  }
}
