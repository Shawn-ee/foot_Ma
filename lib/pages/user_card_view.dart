import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:chatapp_firebase/service/storage_function/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chatapp_firebase/service/storage_function/storage.dart';


class MasseurCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final double rating;
  final double distance;
  final String uid;
  final VoidCallback onTap;

  const MasseurCard({
    Key? key,
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.distance,
    required this.onTap,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    FileStorageService fileStorageService = FileStorageService();
    List<String> tags = ['Relaxation', 'Swedish', 'Thai', 'Happy Ending'];
    // String imageUrl = https://firebasestorage.googleapis.com/v0/b/
    // massageking-d3058.appspot.com/o/masseurs%2FTX1%2Fprofile.png?
    // alt=media&token=811adabe-ccb4-478a-a97f-8d94ad5a8cd1;
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 2.0,
        margin: EdgeInsets.all(4),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: fileStorageService.loadProfileUrl(uid), // Assuming this fetches the image URL
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 150.0,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return SizedBox(
                    height: 150.0,
                    width: double.infinity,
                    child: Center(child: Icon(Icons.error)),
                  );
                }
                return Image.network(
                  snapshot.data!, // Use the loaded image URL
                  fit: BoxFit.cover,
                  height: 150.0,
                  width: double.infinity,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    '$distance km',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
// Handle like action
                  },
                  child: Icon(Icons.thumb_up_alt_outlined, size: 20),
                ),
                SizedBox(width: 12),
                InkWell(
                  onTap: () {
// Handle comment action
                  },
                  child: Icon(Icons.comment_outlined, size: 20),
                ),
                SizedBox(width: 8.0),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            Wrap(
              spacing: 8.0, // Space between tags
              children: tags.map((tag) => Text(
                tag,
                style: TextStyle(
                  fontSize: 12, // Smaller text size for the tags
                  color: Colors.black, // Tag text color
// Add other styles if needed
                ),
              )).toList(),
            )

            // ... rest of your existing layout for rating, tags, etc. ...
          ],
        ),
      ),
    );
  }
}
