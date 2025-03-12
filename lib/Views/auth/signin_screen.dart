import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/forget_password.dart';
import 'package:testappbita/Views/auth/signup_screen.dart';
import 'package:testappbita/Views/auth/welcom_custom_widget.dart';
import 'package:testappbita/controller/auth_controller/auth_controller.dart';
import 'package:testappbita/controller/password_controller.dart';

class Signin extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final PasswordController passwordController = Get.put(PasswordController());
  final TextFieldController textFieldController =
      Get.put(TextFieldController());
  // final CheckBoxController checkBoxController = Get.put(CheckBoxController());

  final RxBool isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Welcome to Bita Homes",
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Get.isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.01))),
                  width: Get.width * 0.9,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) => textFieldController.checkFields(),
                        controller: _authController.signinEmailController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: "Bita-Homes ID (Email)",
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.6))),
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: Get.width * 0.1,
                            height: 1,
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.2),
                            width: Get.width * 0.78,
                            height: 1,
                          ),
                        ],
                      ),
                      Obx(() => TextField(
                            onChanged: (value) =>
                                textFieldController.checkFields(),
                            controller:
                                _authController.signinPasswordController,
                            obscureText:
                                !passwordController.isPasswordVisible.value,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.6)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  passwordController.isPasswordVisible.toggle();
                                },
                                icon: Icon(
                                  passwordController.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => GestureDetector(
                      onTap: () => isChecked.value = !isChecked.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isChecked.value
                                        ? Color(0xFF28C38F)
                                        : Colors.grey),
                                shape: BoxShape.circle,
                                color: isChecked.value
                                    ? Color(0xFF28C38F)
                                    : Colors.transparent,
                              ),
                              child: isChecked.value
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            isChecked.value ? "Remember Me" : "Remember Me",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            Spacer(),
            Center(
              child: Column(
                children: [
                  RoundRectangleButton(
                    size: Get.width * 0.88,
                    text: "LOGIN",
                    color: Color(0xFF28C38F),
                    onTap: () {
                      _authController.signinFun(context);
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(SignupScreen());
                            _authController.signinEmailController.clear();
                            _authController.signinPasswordController.clear();
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF28C38F),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(Forgetpassword());
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF28C38F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
