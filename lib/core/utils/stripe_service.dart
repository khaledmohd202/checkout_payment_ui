import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final ApiService apiService = ApiService();

  // First Step: Create a Payment Intent
  // This function creates a payment intent on the server side
  // and returns a PaymentIntentModel object.
  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    var response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      url: ApiKeys.createPaymentIntentUrl,
      token: ApiKeys.secretKey,
    );

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);

    return paymentIntentModel;
  }

  // Second Step: Initialize the Payment Sheet
  // This function initializes the payment sheet with the
  // payment intent client secret received from the server.
  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Checkout Payment UI',
      ),
    );
  }

  // Third Step: Present the Payment Sheet
  // This function presents the payment sheet to the user
  // and waits for the user to complete the payment.
  Future presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true; // Payment successful
    } on StripeException catch (e) {
      throw ('Error presenting payment sheet: ${e.error.localizedMessage}');
    }
  }

  Future makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {


    // Step 1: Create a Payment Intent
    // This will call the server to create a payment intent
    // and return the client secret needed to initialize the payment sheet.
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);

    // Step 2: Initialize the Payment Sheet
    // This will set up the payment sheet with the client secret.
    await initPaymentSheet(
      paymentIntentClientSecret: paymentIntentModel.clientSecret!,
    );

    // Step 3: Present the Payment Sheet
    // This will display the payment sheet to the user.
    await presentPaymentSheet();
  }

  // Future<void> confirmPayment() async {
  //   try {
  //     await Stripe.instance.confirmPayment();
  //   } catch (e) {
  //     print('Error confirming payment: $e');
  //   }
  // }
  // Future<void> handlePaymentError() async {
  //   try {
  //     await Stripe.instance.handlePaymentError();
  //   } catch (e) {
  //     print('Error handling payment error: $e');
  //   }
  // }
  // Future<void> handlePaymentSuccess() async {
  //   try {
  //     await Stripe.instance.handlePaymentSuccess();
  //   } catch (e) {
  //     print('Error handling payment success: $e');
  //   }
  // }
  // Future<void> handlePaymentSheetResult() async {
  //   try {
  //     await Stripe.instance.handlePaymentSheetResult();
  //   } catch (e) {
  //     print('Error handling payment sheet result: $e');
  //   }
  // }
  // Future<void> handlePaymentIntent() async {
  //   try {
  //     await Stripe.instance.handlePaymentIntent();
  //   } catch (e) {
  //     print('Error handling payment intent: $e');
  //   }
  // }
  // Future<void> handlePaymentMethod() async {
  //   try {
  //     await Stripe.instance.handlePaymentMethod();
  //   } catch (e) {
  //     print('Error handling payment method: $e');
  //   }
  // }
  // Future<void> handlePaymentConfirmation() async {
  //   try {
  //     await Stripe.instance.handlePaymentConfirmation();
  //   } catch (e) {
  //     print('Error handling payment confirmation: $e');
  //   }
  // }
  // Future<void> handlePaymentCancellation() async {
  //   try {
  //     await Stripe.instance.handlePaymentCancellation();
  //   } catch (e) {
  //     print('Error handling payment cancellation: $e');
  //   }
  // }
  // Future<void> handlePaymentIntentCancellation() async {
  //   try {
  //     await Stripe.instance.handlePaymentIntentCancellation();
  //   } catch (e) {
  //     print('Error handling payment intent cancellation: $e');
  //   }
  // }
  // Future<void> handlePaymentIntentConfirmation() async {
  //   try {
  //     await Stripe.instance.handlePaymentIntentConfirmation();
  //   } catch (e) {
  //     print('Error handling payment intent confirmation: $e');
  //   }
  // }
  // Future<void> handlePaymentIntentSetup() async {
  //   try {
  //     await Stripe.instance.handlePaymentIntentSetup();
  //   } catch (e) {
  //     print('Error handling payment intent setup: $e');
  //   }
  // }
  // Future<void> handlePaymentIntentSetupIntent() async {
  //   try {
  //     await Stripe.instance.handlePaymentIntentSetupIntent();
  //   } catch (e) {
  //     print('Error handling payment intent setup intent: $e');
  //   }
  // }
}
