import 'dart:developer';

import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/repos/checkout_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meta/meta.dart';

part 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentState> {
  StripePaymentCubit(this.checkoutRepo) : super(StripePaymentInitial());
  final CheckoutRepo checkoutRepo;

  // Future makePayment({
  //   required PaymentIntentInputModel paymentIntentInputModel,
  // }) async {
  //   emit(StripePaymentLoading());

  //   var data = await checkoutRepo.makePayment(
  //     paymentIntentInputModel: paymentIntentInputModel,
  //   );


  //   data.fold(
  //     (left) => emit(StripePaymentFailure(errorMessage: left.errorMessage)),
  //     (right) => emit(StripePaymentSuccess()),
  //   );
  // }

  Future<void> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    emit(StripePaymentLoading());

    try {
      final data = await checkoutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel,
      );

      data.fold(
        (left) {
          emit(StripePaymentFailure(errorMessage: left.errorMessage));
        },
        (right) async {
          try {
            emit(StripePaymentSuccess());
          } on StripeException catch (e) {
            // Handle Stripe cancelation & other failures
            emit(
              StripePaymentFailure(
                errorMessage: e.error.localizedMessage ?? "Payment failed",
              ),
            );
          } catch (e) {
            emit(StripePaymentFailure(errorMessage: e.toString()));
          }
        },
      );
    } catch (e) {
      emit(StripePaymentFailure(errorMessage: e.toString()));
    }
  }

  @override
  void onChange(Change<StripePaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
