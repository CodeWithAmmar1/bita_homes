import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/set_password.dart';
import 'package:testappbita/Views/auth/signin_screen.dart';
import 'package:testappbita/Views/auth/welcom_custom_widget.dart';
import 'package:testappbita/controller/auth_controller/auth_controller.dart';
import 'package:testappbita/controller/password_controller.dart';

class SignupScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextFieldController textFieldController =
      Get.put(TextFieldController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.13),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create a BITA-HOMES-LINKED ID",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "This will be your BITA-HOMES ID for managing your device. We will send you an email to this address for verification.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 20), // Space before the text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Location",
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    readOnly: true,
                    controller: _authController.userNameController,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.location_on_rounded, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Get.isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      hintText: "Select Country",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                        onPressed: () {
                          showCountryPicker(
                            context: context,
                           
                            showWorldWide: true, // Show worldwide option
                            countryListTheme: CountryListThemeData(
                              flagSize: 25, // Adjust flag size
                              backgroundColor: Get.isDarkMode
                                  ? Colors.black
                                  : Colors.white, // Dark mode support
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black), // Text styling
                              bottomSheetHeight:
                                  600, // Adjust height of the dialog
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              inputDecoration: InputDecoration(
                                hintText: "Search country...",
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            onSelect: (Country country) {
                              _authController.userNameController.text =
                                  country.name;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (value) => textFieldController.checkFields(),
                    controller: _authController.emailController,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.email, color: Colors.grey), // Email Icon
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Get.isDarkMode
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.white,
                        hintText: "Bita-Homes ID (Email)",
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.6))),
                  ),
                ],
              ),
            ),
            Spacer(), // Pushes the button to the bottom
        
            Center(
              child: Column(
                children: [
                  RoundRectangleButton(
                  
                    size: Get.width * 0.88,
                    text: "Next",
                    color: Color(0xFF28C38F),
                    onTap: () {
                      
                      //  _authController.emailController.clear();
                      if ( 
                          _authController.emailController.text.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please fill in all fields",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Color(0xFF28C38F),
                          colorText: Colors.white,
                        );
                      } else {
                        Get.to(Setpassword(),arguments: {
                          "email": _authController.emailController.text,

                        });
                        
                        
                      }
                    },
                  ),
                  SizedBox(height: 15), // Space below button
                  GestureDetector(
                      onTap: () {
                        print("Navigate to Login Screen");
                        Get.to(Signin()); // Navigate to login screen
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "I'm already a member. ",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(Signin());
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize:
                                    14, // Same size as the previous text for consistency
                                color: Color(0xFF28C38F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
