import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sayed_ketab/controller/home_controller.dart';
import 'package:sayed_ketab/screens/home.dart';
import 'package:sayed_ketab/screens/subjects.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String studentName = '';
  String className = '';
  String studentId = '';
  String classId = '';
  String totaldays = '';

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/data/json_stdData_test.json');
    final data = await json.decode(response);
    setState(() {
      setState(() {
        studentName = data['student']['stdname'];
        className = data['student']['classname'];
        studentId = data['student']['stdid'];
        classId = data['student']['classid'];
        totaldays = data['attendance']['totaldays'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<HomeController>().showSubjects();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading:
              GetBuilder<HomeController>(builder: (HomeController controller) {
            return IconButton(
                onPressed: () {
                  controller.showSubjects();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ));
          }),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images/stdGirl.png'),
                ),
                const SizedBox(height: 24),
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.class_,
                  label: 'الصف',
                  value: className,
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: 'عدد أيام الحضور',
                  value: totaldays,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoCard(
    {required IconData icon, required String label, required String value}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
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
