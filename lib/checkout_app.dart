import 'package:checkout_payment_ui/features/checkout/presentation/views/my_cart_view.dart';
import 'package:flutter/material.dart';

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyCartView());
  }
}

// PaymentIntentModel create payment intent (amount, currency, customerId)
// KeySecret createEphemeralKey(customerId)
// init payment sheet (merchantDisplayName, intentClientSecret, ephemeralKeySecret)
// Present payment sheet ()
