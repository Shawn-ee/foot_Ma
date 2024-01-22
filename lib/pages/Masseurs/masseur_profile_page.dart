import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../classes/Projects.dart';
import '../../service/storage_function/storage.dart';

import 'booking_popup.dart';
import 'comment_section.dart';
class MasseurProfilePage extends StatefulWidget {
  final String masseurId;

  MasseurProfilePage({Key? key, required this.masseurId}) : super(key: key);
  @override
  _MasseurProfilePageState createState() => _MasseurProfilePageState();
}

class _MasseurProfilePageState extends State<MasseurProfilePage> {

  double get totalPrice => massageProjects.fold(0, (sum, project) => sum + project.totalPrice);
  final List<Project> massageProjects = [
    Project(name: 'Relaxing Massage', timeLength: '60 mins', price: 218, description: 'A soothing massage to relieve stress and relax muscles.'),
    Project(name: 'Deep Tissue Massage', timeLength: '45 mins', price: 250, description: 'Targets deep layers of muscle and connective tissue.'),
    Project(name: 'Swedish Massage', timeLength: '50 mins', price: 200, description: 'Gentle and relaxing, perfect for first-time massage goers.'),
    Project(name: 'Hot Stone Massage', timeLength: '70 mins', price: 300, description: 'Uses heated stones for deep warmth and muscle relaxation.'),
    Project(name: 'Aromatherapy Massage', timeLength: '60 mins', price: 220, description: 'Combines soft, gentle pressure with the use of essential oils.'),
    Project(name: 'Reflexology', timeLength: '30 mins', price: 150, description: 'Focuses on pressure points in the feet, hands, and ears.'),
    Project(name: 'Shiatsu Massage', timeLength: '60 mins', price: 240, description: 'A form of Japanese bodywork focusing on pressure points.')
  ];
  final FileStorageService fileStorageService = FileStorageService();
  final PageController _pageController = PageController();
  Map<String, dynamic> masseurProfileData = {};
  bool isLoading = true;
  String? errorMessage;
  List<String> picArray = [];
  void showBookingPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookingPopup(initialProjects: massageProjects);
      },
    );
  }

  void incrementQuantity(Project project) {
    setState(() {
      project.incrementQuantity();
    });
  }

  void decrementQuantity(Project project) {
    setState(() {
      project.decrementQuantity();
    });
  }


  @override
  void initState() {
    super.initState();
    fetchMasseur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400, // Fixed height for the image carousel
              child: Stack(
                  children:[PageView.builder(
                  controller: _pageController,
                  itemCount: picArray.isNotEmpty ? picArray.length : 1,
                  itemBuilder: (context, index) {
                  return picArray.isNotEmpty
                      ? Image.network(
                      picArray[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Text('Failed to load image'); // Error text or widget
                    },
                  )
                      : Container(
                      color: Colors.grey[300],
                      child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[700],
                    ),
                  );
                },
              ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: picArray.isNotEmpty ? picArray.length : 1,
                          effect: WormEffect(), // your preferred effect
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Name and distance side by side
                      Expanded(
                        flex: 2, // Adjust the flex to control space allocation
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              masseurProfileData['display_name'] ?? 'HOMIE',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${masseurProfileData['distance'] ?? 0} mile', // Assuming distance is in kilometers
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(), // This will push the rating to the right
                      // Rating stars with number
                      RatingBarIndicator(
                        rating: masseurProfileData['rating'] ?? 0.0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 25.0,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(width: 8), // Spacing between rating stars and number
                      Text(
                        (masseurProfileData['rating'] ?? 0.0).toStringAsFixed(1), // Rating number
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 8.0),
                  Divider(
                    color: Colors.grey, // Color of the divider
                    thickness: 1, // Thickness of the divider line
                    indent: 20, // Starting space (left margin)
                    endIndent: 20, // Ending space (right margin)
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'About Me:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    masseurProfileData['description']?? "a good one",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
        // Expanded(
        Padding(
          padding: const EdgeInsets.all(16.0),

            child: CommentsList(masseurId: widget.masseurId), // This will be your comments list

        )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white, // Set the background color of the container
        padding: EdgeInsets.all(8), // Add padding around the button
        child: ElevatedButton(
          onPressed: () {
            showBookingPopup(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Button background color
            onPrimary: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners for the button
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0), // Vertical padding inside the button
          ),
          child: Text(
            "BOOK",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),



    );
  }
  Future<void> fetchMasseur() async {
    try {
      // Fetch the masseur profile data from Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await firestore.collection('masseurs').doc(widget.masseurId).get();
      Map<String, dynamic> data;
      if (snapshot.exists) {
        // Convert the document to a Map
        data = snapshot.data() as Map<String, dynamic>;
      } else {
        // Handle the case when the document does not exist
        print('Masseur not found');
        data = {}; // Return an empty map or handle as needed
      }
      // Fetch the profile image URL
      List<String> url = await fileStorageService.loadAllUrls(widget.masseurId);
      List<String> imageArray = [];
      if (url != null && url.isNotEmpty) {
        imageArray=url;
      }
      print('imagearray');
      print(imageArray);

// Update the state with fetched data
      setState(() {
        masseurProfileData = data;
        picArray = imageArray;
        isLoading = false;
      });

    } catch (e) {
      print('error right here');
      // Handle any errors here
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }
}
