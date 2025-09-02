import 'dart:developer';

import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

void executePayPalPayment(
  BuildContext context,
  ({AmountModel amountModel, ItemListModel itemList}) transactionData,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: ApiKeys.paypalClientId,
        secretKey: ApiKeys.paypalSecretKey,
        transactions: [
          {
            "amount": transactionData.amountModel.toJson(),
            "description": "The payment transaction description.",
            "item_list": transactionData.itemList.toJson(),
          },
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ThankYouView()),
            (route) {
              if (route.settings.name == '/') {
                return true;
              } else {
                return false;
              }
            },
          );
        },
        onError: (error) {
          // log("onError: $error");
          // Navigator.pop(context);

          SnackBar snackBar = SnackBar(content: Text(error.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyCartView()),
            (route) => false,
          );
        },
        onCancel: () {
          debugPrint('cancelled:');
          Navigator.pop(context);
        },
      ),
    ),
  );
}
