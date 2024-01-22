import 'package:chatapp_firebase/service/storage_function/sharepreferenceinfo.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/pages/forum_section/forum_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'bottom_navigation_bar.dart';
import 'masseur.dart';
import 'Orders.dart';
import 'profilepages/Profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String _currentPage = 'Groups';
  String userRole = ""; // 'customer' or 'masseur'

  int _selectedIndex = 0;
  List<Widget> _pages = [
    HomeContent(), // index 0
    Masseur(), // index 1
    OrdersPage(), // index 2
    ProfilePage(userId: ''), // index 3
  ];

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }
  gettingUserData() async {
    try {
      // Retrieve user role
      String? roleValue = await HelperFunctions.getUserRoleFromSF();
      if (roleValue != null) {
        setState(() {
          userRole = roleValue;
        });
      }

      // Retrieve user email
      String? userEmail = await HelperFunctions.getUserEmailFromSF();
      if (userEmail != null) {
        setState(() {
          email = userEmail;
        });
      }

      // Retrieve user name
      String? userNameValue = await HelperFunctions.getUserNameFromSF();
      if (userNameValue != null) {
        setState(() {
          userName = userNameValue;
        });
      }

      // Get user groups
      var snapshot = await DatabaseService(
          uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups();
      setState(() {
        groups = snapshot;
      });
    } catch (e) {
      // Handle any errors here
      print('Error getting user data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigator logic or page update logic goes here
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );

  }

}

