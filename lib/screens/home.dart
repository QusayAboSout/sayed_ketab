import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sayed_ketab/classes/colors.dart';
import 'package:sayed_ketab/controller/home_controller.dart';
import 'package:sayed_ketab/screens/profile.dart';
import 'package:sayed_ketab/screens/subjects.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (context) {
        return Scaffold(
          body: IndexedStack(
            index: controller.stIndex(),
            children: const [
              Subjects(),
              ProfilePage(),
            ],
          ),
            // backgroundColor: const Color.fromRGBO(0, 168, 209, 1),
            // selectedItemColor: Colors.white,
            // unselectedItemColor: Colors.white70,
            // selectedFontSize: 16,
            // unselectedFontSize: 14,
            bottomNavigationBar: BottomAppBar(
              color: AppColors.BACKGROUND_COLOR,
              // color: const Color(0xFFFFD0D6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GetBuilder<HomeController>(builder: (HomeController controller) {
                    return IconButton(
                      icon: const Icon(Icons.menu_book_rounded, color: AppColors.LIGHT_TEXT),
                      onPressed: () {
                        controller.showSubjects();
                      },
                    );
                  }),
                  GetBuilder<HomeController>(builder: (HomeController controller) {
                    return IconButton(
                      icon: const Icon(
                        Icons.person,
                        color: AppColors.LIGHT_TEXT,
                      ),
                      onPressed: () {
                        controller.showProfile();
                      },
                    );
                  }),
                ],
              ),
            ),
           
        );
      }
    );
  }
}