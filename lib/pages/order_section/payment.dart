import 'package:flutter/material.dart';

enum PaymentMethod { googlePay, balance, cardPay }

class PaymentMethodWidget extends StatefulWidget {
  @override
  _PaymentMethodWidgetState createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  PaymentMethod? _selectedMethod;
  final TextEditingController _cardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Google Pay'),
          leading: Radio<PaymentMethod>(
            value: PaymentMethod.googlePay,
            groupValue: _selectedMethod,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Balance'),
          leading: Radio<PaymentMethod>(
            value: PaymentMethod.balance,
            groupValue: _selectedMethod,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Card Pay'),
          leading: Radio<PaymentMethod>(
            value: PaymentMethod.cardPay,
            groupValue: _selectedMethod,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
        ),
        if (_selectedMethod == PaymentMethod.cardPay)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Number',
                // Add other fields and validation as needed
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }
}
