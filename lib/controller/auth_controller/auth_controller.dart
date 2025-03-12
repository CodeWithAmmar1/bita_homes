
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/signin_screen.dart';
import 'package:testappbita/services/firebase_service.dart';


class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController signinEmailController = TextEditingController();
  final TextEditingController signinPasswordController =
      TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isPasswordVisibleReg = false.obs;
  RxBool isPasswordVisibleConfirm = false.obs;
  RxBool isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString userName = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserName();
  }
    

  toggle() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  toggleReg() {
    isPasswordVisibleReg.value = !isPasswordVisibleReg.value;
  }

  toggleConfirm() {
    isPasswordVisibleConfirm.value = !isPasswordVisibleConfirm.value;
  }

  Future<void> getUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      userName.value = userDoc['user'] ?? 'No Name';
    }
  }

  Future<void> signupFun(context) async {
    isLoading.value = true;
    await FirebaseService().register(
      context,
      // userNameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text
    );
    isLoading.value = false;
  }

  Future<void> signinFun(BuildContext context) async {
    isLoading.value = true;

    await FirebaseService().login(
        context, signinEmailController.text, signinPasswordController.text);
    isLoading.value = false;
  }

  logoutFun() {
    isLoading.value = true;
    FirebaseAuth.instance.signOut();
    Get.offAll(() => Signin());
    isLoading.value = false;
  }

}
