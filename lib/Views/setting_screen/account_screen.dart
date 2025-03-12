import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/signin_screen.dart';
import 'package:testappbita/controller/auth_controller/auth_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthController _authController=Get.put(AuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  String username = "Bita Homes";
  String email = "Example@gmail.com";

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserData();
  }

  /// Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    if (_user != null) {
      setState(() {
        email = _user!.email ?? "No Email";
      });

      DocumentSnapshot userDoc = await _firestore.collection("users").doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc["username"] ?? "No Name";
        });
      }
    }
  }

  /// Edit Username Dialog and Update Firebase
  void _editUsername() {
    TextEditingController controller = TextEditingController(text: username);
    Get.defaultDialog(
      title: "Edit Name",
      backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
      titleStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
      content: TextField(
        controller: controller,
        style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter new name",
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          String newName = controller.text;
          if (newName.isNotEmpty && _user != null) {
            await _firestore.collection("users").doc(_user!.uid).update({"username": newName});
            setState(() {
              username = newName;
            });
          }
          Get.back();
        },
        child: Text("Save"),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
    );
  }

  /// Change Password
  void _changePassword() {
    if (_user != null) {
      _auth.sendPasswordResetEmail(email: _user!.email!).then((_) {
        Get.snackbar("Success", "Password reset email sent to $email.",
            backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.white,
            colorText: Get.isDarkMode ? Colors.white : Colors.black);
      }).catchError((error) {
        Get.snackbar("Error", error.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
      });
    }
  }

  /// Logout Function


  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
     var image = Get.arguments != null ? Get.arguments['image'] : 'assets/images/default.jpg';
    return Scaffold(
      backgroundColor:Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      // appBar: AppBar(
      //   title: Text(""),
      //   backgroundColor:Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      //   iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      //   titleTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20),
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height*0.13,),
            
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('$image'), // Replace with user's profile picture
            ),
              
            SizedBox(height: 15),
            Text(
              username,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
              
            Text(
              email,
              style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[400] : Colors.grey),
            ),
              
            SizedBox(height: 40),
              
            // Centered Container
            SizedBox(
              height: Get.height*0.6,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      width: Get.width * 0.9,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black45 : Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Row 1: Edit Name
                          ListTile(
                            leading: Icon(Icons.person, color: isDark ? Colors.greenAccent : Colors.green),
                            title: Text(
                              "Name",
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(username, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                                Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white70 : Colors.black),
                              ],
                            ),
                            onTap: _editUsername,
                          ),
                    
                          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    
                          // Row 2: Change Password
                          ListTile(
                            leading: Icon(Icons.lock, color: isDark ? Colors.orangeAccent : Colors.orange),
                            title: Text(
                              "Change Password",
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white70 : Colors.black),
                            onTap: _changePassword,
                          ),
                    
                          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    
                          // Row 3: Login Security
                          ListTile(
                            leading: Icon(Icons.security, color: isDark ? Colors.blueAccent : Colors.blue),
                            title: Text(
                              "Login Security",
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white70 : Colors.black),
                            onTap: () {
                              Get.snackbar("Login Security", "Navigate to login security settings.",
                                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                                  colorText: isDark ? Colors.white : Colors.black);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: ElevatedButton(
                  onPressed: _authController.logoutFun,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
                ],
              ),
            ),
              
           
           
          ],
        ),
      ),
    );
  }
}
