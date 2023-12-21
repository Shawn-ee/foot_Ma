import 'package:flutter/material.dart';
import 'appDrawer.dart';
class NearbyMasseurPage extends StatefulWidget {
  @override
  _NearbyMasseurPageState createState() => _NearbyMasseurPageState();
}

class _NearbyMasseurPageState extends State<NearbyMasseurPage> {
  // Add your state and methods here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Masseurs'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: Center(
        // Replace with your page content
        child: Text('List of Nearby Masseurs'),
      ),
    );
  }
}
