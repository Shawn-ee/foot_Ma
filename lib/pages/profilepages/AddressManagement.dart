import 'package:flutter/material.dart';

class AddressManagementPage extends StatefulWidget {
  @override
  _AddressManagementPageState createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  // Mock data for the list of addresses
  List<Map<String, String>> addresses = [
    {
      'name': 'Home',
      'address': '123 Main St, New York, NY',
    },
    {
      'name': 'Work',
      'address': '456 Park Ave, New York, NY',
    },
    // Add more addresses as needed
  ];

  void _addAddress() {
    // Implement the logic to add a new address
    print('Add address');
  }

  void _editAddress(int index) {
    // Implement the logic to edit an existing address
    print('Edit address $index');
  }

  void _deleteAddress(int index) {
    // Implement the logic to delete an address
    print('Delete address $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addAddress,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          var address = addresses[index];
          return ListTile(
            title: Text(address['name']!),
            subtitle: Text(address['address']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editAddress(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteAddress(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
