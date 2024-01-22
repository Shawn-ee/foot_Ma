import 'package:chatapp_firebase/pages/order_section/payment.dart';
import 'package:flutter/material.dart';
import '../../classes/Projects.dart';
import '../../widgets/coupon.dart';

class OrderPage extends StatefulWidget {
  final List<Project> selectedProjects;

  OrderPage({Key? key, required this.selectedProjects}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<String> availableTimeSlots = ["12:00", " 18:00"]; // This should be fetched or passed to this widget
  String? selectedTimeSlot;
  double get totalPrice => widget.selectedProjects.fold(0, (sum, project) => sum + (project.price * project.quantity));
  String? note;
  TextEditingController noteController = TextEditingController();
  @override
  void initState() {
    super.initState();
    availableTimeSlots = getAvailableTimeSlots(); // You will need to implement this
  }

  List<String> getAvailableTimeSlots() {
    // You will need to replace this with your actual logic to fetch available time slots
    return ["10:00 AM", "12:00 PM", "2:00 PM", "4:00 PM"];
  }

  void onTimeSlotSelected(String? timeSlot) {
    setState(() {
      selectedTimeSlot = timeSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Summary')),
      body: ListView(
        children:[
          _buildOrderSummary(),
          _buildTimeSlotSection(),
          CouponWidget(),
          _noteSection(),
          PaymentMethodWidget()

        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ¥${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to place an order
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text('Place Order', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    List<Widget> projectSummaries = widget.selectedProjects
        .where((project) => project.quantity > 0)
        .map((project) => ListTile(
      title: Text(project.name),
      subtitle: Text('${project.timeLength} - ¥${project.price}'),
      trailing: Text('x${project.quantity}'),
    ))
        .toList();

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ...projectSummaries,
        ],
      ),
    );
  }

  Widget _buildTimeSlotSection() {
    return ListTile(
      title: Text('Select a Time Slot'),
      trailing: DropdownButton<String>(
        value: selectedTimeSlot,
        hint: Text('Choose a slot'),
        onChanged: onTimeSlotSelected,
        items: availableTimeSlots.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _noteSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: noteController,
        decoration: InputDecoration(
          labelText: 'Add a note (optional)',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null, // Allows the TextField to grow vertically
        minLines: 1, // Starts with 1 line
      ),
    );
  }

}
