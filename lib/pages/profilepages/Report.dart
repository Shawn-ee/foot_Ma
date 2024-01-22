import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reportController = TextEditingController();

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Implement the logic to handle report submission, like sending to an API or database
      String reportText = _reportController.text;
      print('Report submitted: $reportText');
      // Show a snackbar or dialog for a successful submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your report has been submitted. Thank you!'),
          duration: Duration(seconds: 2),
        ),
      );
      // Clear the text field
      _reportController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report an Issue'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _reportController,
                maxLines: 6, // Gives the text field a height that allows for multiple lines of text
                decoration: InputDecoration(
                  hintText: 'Describe the issue you encountered',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description of the issue.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: Text('Submit Report'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent, // Button color for reporting issues
                  onPrimary: Colors.white, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
