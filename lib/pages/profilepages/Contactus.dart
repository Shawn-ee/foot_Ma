import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  // Replace with your actual contact details
  final String email = 'support@example.com';
  final String phone = '+1234567890';
  final String website = 'https://www.example.com';

  // Function to launch URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
              onTap: () => _launchURL('mailto:$email'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text(phone),
              onTap: () => _launchURL('tel:$phone'),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Website'),
              subtitle: Text(website),
              onTap: () => _launchURL(website),
            ),
            // Add more contact options as needed
          ],
        ),
      ),
    );
  }
}
