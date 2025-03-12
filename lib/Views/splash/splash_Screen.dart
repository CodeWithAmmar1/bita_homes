// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:testappbita/Views/bottom_NavBar/nav_bar.dart';
// import 'package:video_player/video_player.dart';




// class SplashController extends GetxController {
//   late VideoPlayerController videoController;
//   RxBool isVideoReady = false.obs; 

//   @override
//   void onInit() {
//     super.onInit();

//     videoController = VideoPlayerController.asset('assets/logo_animation.mp4')
//       ..initialize().then((_) {
//         isVideoReady.value = true; 
//         videoController.play();
//       });

//     videoController.setLooping(false);

//     videoController.addListener(() {
//       if (videoController.value.position >= videoController.value.duration) {
//         navigateToHome();
//       }
//     });

//     Future.delayed(Duration(seconds: 10), navigateToHome);
//   }

//   void navigateToHome() {
//     if (Get.currentRoute == "/") {
//       Get.off(() => NavBar());
//     }
//   }

//   @override
//   void onClose() {
//     videoController.dispose();
//     super.onClose();
//   }
// }



// class SplashScreen extends StatelessWidget {
//   final SplashController controller = Get.put(SplashController());

//    SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
//       body: Center(
//         child: Obx(() {
//           if (!controller.isVideoReady.value) {
//             return CircularProgressIndicator();
//           }
//           return AspectRatio(
//             aspectRatio: controller.videoController.value.aspectRatio,
//             child: VideoPlayer(controller.videoController),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:testappbita/controller/splash_controller/splash_controller.dart';

class Splash extends StatelessWidget {
  Splash({super.key}) {
    Get.put(SplashController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFC1C1),
                  Color(0xFFB2FF59),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child:
                Image.asset("assets/images/splash.png", width: Get.width * 0.9),
          ),
        ],
      ),
    );
  }
}
