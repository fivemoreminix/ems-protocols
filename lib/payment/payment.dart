import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// PaymentPage is a fullscreen view of billing and payment information for
/// owner accounts. Will allow them to modify payment data and it should update
/// in their account data for billing and stripe for payment method.
class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var companyNameController = TextEditingController();
  var countryController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var addr1Controller = TextEditingController();
  var addr2Controller = TextEditingController();
  var postalController = TextEditingController();
  CardFieldInputDetails? _card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Payment Info')),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$200', style: TextStyle(fontSize: 32)),
                Text('/mo', style: TextStyle(color: Colors.grey, fontSize: 24)),
              ],
            ),
            const Text('Billing Information'),
            TextField(
              decoration: const InputDecoration(hintText: 'Name or company'),
              controller: companyNameController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Country'),
              controller: countryController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'City'),
              controller: cityController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'State'),
              controller: stateController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Address 1'),
              controller: addr1Controller,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Address 2'),
              controller: addr2Controller,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Postal / ZIP code'),
              controller: postalController,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text('Card Details'),
            CardField(
              onCardChanged: (details) => _card = details,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Payment info is always processed securely with Stripe.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {}, // TODO: save payment and billing information.
            )
          ]),
        )));
  }
}
