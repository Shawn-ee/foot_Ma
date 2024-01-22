import 'package:flutter/material.dart';

class Order {
  final String id;
  final String title;
  final String description;
  final double amount;

  Order({required this.id, required this.title, required this.description, required this.amount});
}

class OrdersPage extends StatelessWidget {
  final List<Order> orders = [
    Order(id: '1', title: 'Order 1', description: 'This is the first order', amount: 99.99),
    Order(id: '2', title: 'Order 2', description: 'This is the second order', amount: 199.99),
    Order(id: '3', title: 'Order 3', description: 'This is the third order', amount: 299.99),
    Order(id: '4', title: 'Order 1', description: 'This is the first order', amount: 99.99),
    Order(id: '5', title: 'Order 2', description: 'This is the second order', amount: 199.99),
    Order(id: '6', title: 'Order 3', description: 'This is the third order', amount: 299.99),
    // Add more orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => OrderCard(order: orders[i]),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              order.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              order.description,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              '\$${order.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
