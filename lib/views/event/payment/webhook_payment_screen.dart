import 'package:festivalapp/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart';
import 'package:festivalapp/services/stripe/stripe_services.dart';

import 'components/loading_button.dart';

class WebhookPaymentScreen extends StatefulWidget {
  final Event event;
  WebhookPaymentScreen({Key? key, required this.event}) : super(key: key);
  @override
  _WebhookPaymentScreenState createState() => _WebhookPaymentScreenState();
}

class _WebhookPaymentScreenState extends State<WebhookPaymentScreen> {
  CardFieldInputDetails? _card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 20),
          CardField(
            onCardChanged: (card) {
              setState(() {
                _card = card;
              });
            },
          ),
          SizedBox(height: 20),
          LoadingButton(
            onPressed: _card?.complete == true ? _handlePayPress : null,
            text: 'Procéder au paiement',
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayPress() async {
    if (_card == null) {
      return;
    }
    print(widget.event.getPriceStripeFormatted());
    StripeServices()
        .startPayment(event: widget.event)
        .then((stripeTransactionResponse) {
      Navigator.pop(context, stripeTransactionResponse.success);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(stripeTransactionResponse.message),
          backgroundColor:
              (stripeTransactionResponse.success) ? Colors.green : Colors.red));
    });
  }
}
