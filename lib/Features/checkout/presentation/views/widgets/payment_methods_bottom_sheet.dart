import 'package:checkout_payment_ui/Features/checkout/presentation/views/widgets/custom_button_bloc_consumer.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:flutter/material.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  bool isPayPal = false;
  updatePayment({required int index}) {
    if (index == 0) {
      isPayPal = false;
    } else {
      isPayPal = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethodsListView(updatePayment: updatePayment),
          SizedBox(height: 32),
          CustomButtonBlocConsumer(isPayPal: isPayPal),
        ],
      ),
    );
  }
}
