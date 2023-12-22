import 'package:flutter/material.dart';

class user_card extends StatelessWidget {
  final String name;
  final String image;
  final String description;

  user_card({required this.name, required this.image, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(image), // Masseur image
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(description),
                // Add more details or actions here...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
