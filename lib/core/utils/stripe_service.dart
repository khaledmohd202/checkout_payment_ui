import 'package:checkout_payment_ui/Features/checkout/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/init_payment_sheet_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:dio/dio.dart';
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
      contentType: Headers.formUrlEncodedContentType,
      url: ApiKeys.createPaymentIntentUrl,
      token: ApiKeys.secretKey,
    );

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);

    return paymentIntentModel;
  }

  // Second Step: Initialize the Payment Sheet
  // This function initializes the payment sheet with the
  // payment intent client secret received from the server.
  Future initPaymentSheet({
    required InitPaymentSheetInputModel initPaymentSheetInputModel,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initPaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            initPaymentSheetInputModel.ephemeralKeySecret,
        customerId: initPaymentSheetInputModel.customerId,
        merchantDisplayName: 'Checkout Payment UI',
      ),
    );
  }

  // Third Step: Present the Payment Sheet
  // This function presents the payment sheet to the user
  // and waits for the user to complete the payment.
  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    // Step 1: Create a Payment Intent
    // This will call the server to create a payment intent
    // and return the client secret needed to initialize the payment sheet.
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemeralKeyModel = await createEphemeralKey(
      customerId: paymentIntentInputModel.customerId,
    );

    var initPaymentSheetInputModel = InitPaymentSheetInputModel(
      clientSecret: paymentIntentModel.clientSecret!,
      customerId: paymentIntentInputModel.customerId,
      ephemeralKeySecret: ephemeralKeyModel.secret!,
    );

    // Step 2: Initialize the Payment Sheet
    // This will set up the payment sheet with the client secret.
    await initPaymentSheet(
      initPaymentSheetInputModel: initPaymentSheetInputModel,
    );

    // Step 3: Present the Payment Sheet
    // This will display the payment sheet to the user.
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey({
    required String customerId,
  }) async {
    var response = await apiService.post(
      body: {'customer': customerId},
      contentType: Headers.formUrlEncodedContentType,
      url: ApiKeys.ephemeralKeysUrl ,
      token: ApiKeys.secretKey,
      headers: {
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
        'Stripe-Version': '2025-07-30.basil',
      },
    );

    var ephemeralKeyModel = EphemeralKeyModel.fromJson(response.data);

    return ephemeralKeyModel;
  }
}
