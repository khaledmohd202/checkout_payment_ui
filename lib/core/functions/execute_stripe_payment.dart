import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/manager/cubit/stripe_payment_cubit.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void executeStripePayment(BuildContext context) {
  PaymentIntentInputModel paymentIntentInputModel = PaymentIntentInputModel(
    amount: '100',
    currency: 'usd',
    customerId: ApiKeys.customerId,
  );
  BlocProvider.of<StripePaymentCubit>(
    context,
  ).makePayment(paymentIntentInputModel: paymentIntentInputModel);
}
