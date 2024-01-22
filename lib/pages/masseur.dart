import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Masseurs/masseur_profile_page.dart';
import 'appDrawer.dart';
import 'user_card_view.dart';

class Masseur extends StatefulWidget {
  @override
  _NearbyMasseurPageState createState() => _NearbyMasseurPageState();
}

class _NearbyMasseurPageState extends State<Masseur> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 26, 16.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for masseurs',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Open filter dialog or menu
                  },
                ),
              ],
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('All'),
                _filterChip('Top Rated'),
                _filterChip('Nearest'),
                _filterChip('Most Popular'),
              ],
            ),
          ),
          // Masseurs Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('masseurs').snapshots(),
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
                    childAspectRatio: (100/ 120), // Adjust based on your content size
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index].data() as Map<String, dynamic>;
                    return MasseurCard(
                      uid: user['uid'],
                      name: user['display_name'] ?? 'No Name',
                      imageUrl: user['profileurl'] ?? 'https://via.placeholder.com/150',
                      description: user['description'] ?? 'No Description',
                      rating: user['rating']?.toDouble() ?? 3.0, // Convert to double if necessary
                      distance: user['distance']?.toDouble() ?? 0.0,
                      onTap: () { Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MasseurProfilePage(masseurId: 'TX1'), // Replace with actual masseur ID or other identifying data
                      )); }, // Convert to double if necessary
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        onSelected: (bool value) {
          // Handle filter logic
        },
      ),
    );
  }

}
