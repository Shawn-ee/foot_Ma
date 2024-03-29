import 'package:chatapp_firebase/service/storage_function/sharepreferenceinfo.dart';
import 'package:chatapp_firebase/service/storage_function/storage.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/auth/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/pages/forum_section/forum_page.dart';
import 'package:chatapp_firebase/pages/group_section/group_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_firebase/pages/nearby_customer_page.dart';
import 'package:chatapp_firebase/pages/nearby_masseur_page.dart';




class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  FileStorageService fileStorageService = FileStorageService();
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String _currentPage = 'Groups';
  String userRole = ""; // 'customer' or 'masseur'

  @override

  // string manipulation


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: fileStorageService.getUserDataFromCache(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Extract user data
          String user_id = snapshot.data!['uid'] ?? '';
          String userName = snapshot.data!['userName'] ?? '';
          String email = snapshot.data!['email'] ?? '';
          String userRole = snapshot.data!['userRole'] ?? '';
          // print(user_id);
          // print(userName);
          // print(email);
          // print(userRole);

          // Build the drawer with user data
          return Drawer(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 50),
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 150,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(
                    height: 2,
                  ),

                  //groups_page
                  ListTile(
                    onTap: () {
                      nextScreenReplace(
                          context,
                          GroupPage());
                    },

                    selected: _currentPage == 'Groups',
                    selectedColor: Theme.of(context).primaryColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.group),
                    title: const Text("Groups", style: TextStyle(color: Colors.black)),
                  ),

                  //Profile_page

                  ListTile(
                    onTap: () {
                      nextScreenReplace(
                          context,
                          ProfilePage(
                            userId: user_id
                          ));
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    selected: true,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.account_circle),
                    title: const Text(
                      "Profile",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  // forum page
                  ListTile(
                    onTap: () {
                      nextScreenReplace(
                          context,
                          ForumPage(

                          ));
                    },
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.forum),
                    title: const Text(
                      "Forum",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  if (userRole == 'customer')
                  //nearby masseur
                    ListTile(
                      onTap: () {
                        setState(() {
                          _currentPage = 'NearbyMasseurs';
                        });
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NearbyMasseurPage()),
                        );
                      },
                      selected: _currentPage == 'NearbyMasseurs',
                      selectedColor: Theme.of(context).primaryColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      leading: const Icon(Icons.healing),
                      title: const Text("Nearby Masseurs", style: TextStyle(color: Colors.black)),
                    ),


                  if (userRole == 'masseur')
                  //nearby customer
                    ListTile(
                      onTap: () {
                        setState(() {
                          _currentPage = 'NearbyCustomers';
                        });
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NearbyCustomerPage()),
                        );
                      },
                      selected: _currentPage == 'NearbyCustomers',
                      selectedColor: Theme.of(context).primaryColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      leading: const Icon(Icons.location_on),
                      title: const Text("Nearby Customers", style: TextStyle(color: Colors.black)),
                    ),




                  //logout button
                  ListTile(
                    onTap: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content: const Text("Are you sure you want to logout?"),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await authService.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => const LoginPage()),
                                            (route) => false);
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ));
        } else {
          // Show loading indicator or placeholder
          return Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );

  }
}
