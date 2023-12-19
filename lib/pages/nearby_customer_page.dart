import 'package:flutter/material.dart';

class NearbyCustomerPage extends StatefulWidget {
  @override
  _NearbyCustomerPageState createState() => _NearbyCustomerPageState();
}

class _NearbyCustomerPageState extends State<NearbyCustomerPage> {
  // Add your state and methods here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Customers'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        // Replace with your page content
        child: Text('List of Nearby Customers'),
      ),
    );
  }
}
