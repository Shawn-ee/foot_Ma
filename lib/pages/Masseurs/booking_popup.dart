import 'package:chatapp_firebase/classes/Projects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../order_section/book_comfirmation.dart';

class BookingPopup extends StatefulWidget {
  final List<Project> initialProjects;

  BookingPopup({Key? key, required this.initialProjects}) : super(key: key);

  @override
  _BookingPopupState createState() => _BookingPopupState();
}

class _BookingPopupState extends State<BookingPopup> {
  late List<Project> massageProjects;
  late double totalPrice;


  @override
  void initState() {
    super.initState();
    // Clone the initial list to have a separate copy for internal state management
    massageProjects = List.from(widget.initialProjects);
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice = massageProjects.fold(0, (sum, project) => sum + project.totalPrice);
  }

  void incrementQuantity(Project project) {
    setState(() {
      project.incrementQuantity();
      calculateTotalPrice();
    });
  }

  void decrementQuantity(Project project) {
    setState(() {
      project.decrementQuantity();
      calculateTotalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor:0.7, // Two-thirds of the screen height
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: massageProjects.length,
                itemBuilder: (context, index) {
                  var project = massageProjects[index];
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text('${project.timeLength} - ${project.price}'),
                                SizedBox(height: 4),
                                Text(
                                  project.description,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => decrementQuantity(project),
                              ),
                              Text(
                                project.quantity.toString(), // Display the current quantity
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => incrementQuantity(project),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2, // gives the price text twice the space compared to the button
                    child: Text(
                      'Total: ${totalPrice.toStringAsFixed(2)}', // Replace with your total price variable
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // This will create space between the text and the button
                  Expanded(
                    flex: 1, // gives the button one portion of space
                    child: ElevatedButton(
                      onPressed: () {
// Only navigate if there are selected projects
                        bool hasSelectedProjects = massageProjects.any((project) => project.quantity > 0);
                        if (hasSelectedProjects) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderPage(selectedProjects: massageProjects.where((p) => p.quantity > 0).toList()),
                            ),
                          );
                        } else {
// Optionally show a message that no projects have been selected
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Button background color
                        onPrimary: Colors.white, // Text color
                        minimumSize: Size(double.infinity, 50), // Set the button to take the full width of its Expanded widget
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Order',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
