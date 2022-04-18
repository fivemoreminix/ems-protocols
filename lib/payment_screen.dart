import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  CardFieldInputDetails? _card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text('Billing Information'),
        Row(
          children: [
            Column(
              children: [
                Text('City'),
                Text('State'),
                Text('Address 1'),
                Text('Address 2'),
                Text('Postal code'),
              ],
            ),
            Column(
              children: [TextField(), TextField()],
            )
          ],
        ),
        Text('Payment Method'),
        CardField(
          onCardChanged: (details) => _card = details,
        )
      ]),
    );
  }
}
