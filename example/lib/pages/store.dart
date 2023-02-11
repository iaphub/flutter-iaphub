import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iaphub_flutter/iaphub_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../stores/index.dart';

class StorePage extends StatelessWidget {
  const StorePage();

  buidProductsList(List<IaphubProduct> products, String emptyText) {
    if (products.isEmpty) {
      return Center(
        child: Text(emptyText, style: TextStyle(fontSize: 18.0)),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () => iapStore.buy(product.sku),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((product?.localizedTitle ?? "No title"), style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 8.0),
                        Text((product?.localizedPrice ?? "No price"), style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                    Spacer(),
                    Observer(
                      builder: (_) {
                        if (iapStore.skuProcessing == product.sku) {
                          return Container(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          );
                        }
                        else {
                          return Container();
                        }
                      }
                    ),
                  ],
                ),
              ),
            )
          );
        },
      );
    }
  }

  buildLink(String text, Function onClick) {
    return (
      InkWell(
        onTap: () => onClick(),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Center(
            child: Text("Products for Sale", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 15.0),
          Observer(
            builder: (_) {
              return buidProductsList(iapStore.productsForSale, "No products for sale");
            }
          ),
          Observer(
            builder: (_) {
              if (iapStore.billingStatus?.error?.code == "billing_unavailable") {
                if (iapStore.billingStatus?.error?.subcode == "play_store_outdated") {
                  return Text("Billing not available, you must update your Play Store App", style: TextStyle(fontSize: 18.0));
                }
                else {
                  return Text("Billing not available, please try again later", style: TextStyle(fontSize: 18.0));
                }
              }
              return Container();
            }
          ),
          SizedBox(height: 30.0),
          Center(
            child: Text("Active Products", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 15.0),
          Observer(
            builder: (_) {
              return buidProductsList(iapStore.activeProducts, "No active products");
            }
          ),
          SizedBox(height: 100.0),
          buildLink("Restore purchases", () => iapStore.restore()),
          SizedBox(height: 30.0),
          buildLink("Manage subscriptions", () => iapStore.showManageSubscriptions()),
          SizedBox(height: 30.0),
          Platform.isIOS ? buildLink("Redeem promo code", () => iapStore.presentCodeRedemptionSheet()) : Container(),
          SizedBox(height: 30.0),
          buildLink("Logout", () => appStore.logout()),
        ],
      ),
    );
  }
}
