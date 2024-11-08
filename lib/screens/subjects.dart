import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sayed_ketab/classes/colors.dart';
import 'package:sayed_ketab/screens/home.dart';
import 'package:sayed_ketab/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  List<dynamic> reviews = [];
  final int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Get.offAll(() => const LoginPage());
  }

  Future<void> loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/data/json_stdData_test.json');
    final data = await json.decode(response);
    setState(() {
      reviews = data["reviews"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('المواد الدرسية'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _logout();
            },
            icon: const Icon(Icons.exit_to_app),
            color: AppColors.DANGER,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(reviews.length, (index) {
            String subjectName = reviews[index]["review1name"];
            return GestureDetector(
              onTap: () {
                Get.to(() => RatingPage(subject: reviews[index]));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 168, 209, 1),
                      Color.fromRGBO(0, 120, 150, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.menu_book_sharp, // Example icon
                      color: Colors.white,
                      size: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subjectName, // Unique name from JSON data
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class RatingPage extends StatefulWidget {
  final Map<String, dynamic> subject;

  const RatingPage({super.key, required this.subject});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  bool showFirstMonth = true; // Track which month's rating to show

  @override
  Widget build(BuildContext context) {
    final sections = widget.subject["review1dets"] ?? [];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.subject["review1name"])),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          final ratings = section["review2dets"] ?? [];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section["review2name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Table widget for custom layout
                  Table(
                    border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.grey.shade300)),
                    columnWidths: {
                      0: FixedColumnWidth(
                          screenWidth * 0.6), // 60% width for criteria
                      1: FixedColumnWidth(
                          screenWidth * 0.3), // 30% width for rating column
                    },
                    children: [
                      // Header Row with Dropdown
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'المعايير',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  value: showFirstMonth
                                      ? 'الفصل الأول'
                                      : 'الفصل الثاني',
                                  underline:
                                      Container(), // Remove underline for clean look
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      showFirstMonth =
                                          (newValue == 'الفصل الأول');
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'الفصل الأول',
                                      child: Text('الفصل الأول'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'الفصل الثاني',
                                      child: Text('الفصل الثاني'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Data Rows
                      ...ratings.map<TableRow>((rating) {
                        // Split the rating value based on underscore
                        final reviewVal = rating["reviewval"] ?? '';
                        final parts = reviewVal.split('_');
                        final firstMonthRating =
                            parts.isNotEmpty ? parts[0] : '';
                        final secondMonthRating =
                            parts.length > 1 ? parts[1] : '';
                        final displayedRating = showFirstMonth
                            ? firstMonthRating
                            : secondMonthRating;

                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                rating["review3name"],
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(displayedRating)),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
