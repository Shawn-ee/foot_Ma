import 'package:flutter/material.dart';
import 'appDrawer.dart';
class NearbyCustomerPage extends StatefulWidget {
  @override
  _NearbyCustomerPageState createState() => _NearbyCustomerPageState();
}

class _NearbyCustomerPageState extends State<NearbyCustomerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Customers'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: Center(
        // Replace with your page content
        child: Text('List of Nearby Customers'),
      ),
    );
  }
}
