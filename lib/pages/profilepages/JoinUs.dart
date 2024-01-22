import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JoinUsPage extends StatelessWidget {
  // Function to handle sending email or navigating to a sign-up form
  void _joinUs() async {
    // This is just a sample email, replace with your actual recruitment email
    const email = 'join@company.com';
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Application for Joining&body=I would like to join your team because...', //add subject and body here
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'We are always looking for talented individuals to join our team. If you are passionate about our mission and want to contribute, we would love to hear from you.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinUs,
              child: Text('Contact Us to Join'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
