import 'package:checkout_payment_ui/Features/checkout/presentation/manager/cubit/stripe_payment_cubit.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:checkout_payment_ui/core/functions/execute_paypal_payment.dart';
import 'package:checkout_payment_ui/core/functions/execute_stripe_payment.dart';
import 'package:checkout_payment_ui/core/functions/get_transactions.dart';
import 'package:checkout_payment_ui/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({super.key, required this.isPayPal});

  final bool isPayPal;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StripePaymentCubit, StripePaymentState>(
      listener: (context, state) {
        if (state is StripePaymentSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const ThankYouView();
              },
            ),
          );
        }

        if (state is StripePaymentFailure) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(content: Text(state.errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
          onTap: () {
            if (isPayPal) {
              var transactionData = getTransactionsData();
              executePayPalPayment(context, transactionData);
            } else {
              executeStripePayment(context);
            }
          },
          isLoading: state is StripePaymentLoading ? true : false,
          text: 'Continue',
        );
      },
    );
  }
}
