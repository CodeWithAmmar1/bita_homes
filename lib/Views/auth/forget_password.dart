import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/welcom_custom_widget.dart';

class Forgetpassword extends StatelessWidget {
  Forgetpassword({super.key});

  final TextEditingController emailcontroller = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void sendPasswordReset() {
    if (emailcontroller.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email",
          backgroundColor: Color(0xFF28C38F), colorText: Colors.white);

      return;
    }

    auth.sendPasswordResetEmail(email: emailcontroller.text.trim()).then((_) {
      Get.snackbar("Success", "We have sent you an email to recover password",
          backgroundColor: Color(0xFF28C38F), colorText: Colors.white);
    }).catchError((error) {
      Get.snackbar("Error", error.toString(),
          backgroundColor: Color(0xFF28C38F), colorText: Colors.white);
    });

    emailcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.15),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password Reset",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "We'll send an email to help you restart\n your Bita-Home ID password",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Get.isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            ),
            RoundRectangleButton(
                size: Get.width * 0.88,
                text: "Send",
                color: Color(0xFF28C38F),
                onTap: (){sendPasswordReset; emailcontroller.clear();}),
          ],
        ),
      ),
    );
  }
}
