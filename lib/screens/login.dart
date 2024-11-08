
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sayed_ketab/classes/colors.dart';
import 'package:sayed_ketab/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _studentID = TextEditingController();
  String? _selectedClass = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

final Map<String, String> studentClasses = {
  '123123123': 'أحمر',
  '111222333': 'أزرق',
};


  void _login() async{
    final id = _studentID.text.trim();
  final selectedClass = _selectedClass;
    if (_formKey.currentState!.validate()) {
if (studentClasses[id] != selectedClass) {
      // Display error if ID doesn't match the class
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الهوية أو الشعبة غير صحيحة"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      // Simulate a network request
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        // Store login status

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم التسجيل بنجاح"),backgroundColor: AppColors.ACCEPT,),
        );
        Get.to(() =>  const Home());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff00B4DB), Color(0xff0083B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'الدخول إلى النظام',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Input Field
                  TextFormField(
                    controller: _studentID,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'رقم هوية الطالب',
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم الهوية';
                      } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                        return 'يرجى ادخال رقم الهوية بشكل صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Input Field
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon:
                          const Icon(Icons.color_lens, color: Colors.white),
                      hintText: 'الشعبة الدراسية',
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: Colors.black,
                    items: ['أحمر', 'أصفر', 'زهري', 'أخضر', 'أزرق']
                        .map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _selectedClass = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار لون';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Login Button with Loading Indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 50,
                    width: _isLoading
                        ? 50
                        : MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff0083B0)),
                            )
                          : const Text(
                              'تسجيل دخول',
                              style: TextStyle(
                                color: Color(0xff0083B0),
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // "Forgot Password?" and "Sign Up" links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: const Text(
                          'من نحن',
                          style: TextStyle(color: Colors.white70, fontSize: 17),
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle sign up
                        },
                        child: const Text(
                          'اتصل بنا',
                          style: TextStyle(color: Colors.white70, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
