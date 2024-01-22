import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appDrawer.dart';
import 'user_card_view.dart';


class NearbyMasseurPage extends StatefulWidget {
  @override
  _NearbyMasseurPageState createState() => _NearbyMasseurPageState();
}

class _NearbyMasseurPageState extends State<NearbyMasseurPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Masseurs'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').where('user_type', isEqualTo: 'masseur').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No masseurs found"));
          }


          List<DocumentSnapshot> users = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 1, // Horizontal space between cards
              mainAxisSpacing: 1, // Vertical space between cards
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;
              // return user_card(
              //   name: user['fullName'] ?? 'No Name',
              //   image: user['image'] ?? 'assets/default.png',
              //   // Replace with a default image path
              //   description: user['description'] ?? 'No Description',
              // );
            },
          );
        },
      ),
    );
  }
}
