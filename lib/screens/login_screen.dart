import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url = Uri.parse('https://darkturquoise-lark-306795.hostingersite.com/guardian/api/login');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone_number': _phoneController.text,
          'password': _passwordController.text,
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == true) {
           final user = data['user'];
           final isGuardian = user['is_guardian'] == true;
           
           if (isGuardian) {
             final prefs = await SharedPreferences.getInstance();
             await prefs.setString('token', data['token'] ?? data['access_token']);
             await prefs.setString('user_data', jsonEncode(user));

             if (mounted) {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('تم تسجيل الدخول بنجاح!'), backgroundColor: Colors.green),
               );
               // Navigate to Home (TODO)
             }
           } else {
             setState(() {
               _errorMessage = 'عذراً، هذا الحساب ليس حساب أمين شرعي.';
             });
           }
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'فشل تسجيل الدخول';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'خطأ في الاتصال بالخادم (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/ministry_logo.jpg', height: 120),
                const SizedBox(height: 16),
                const Text(
                  'وزارة العدل وحقوق الإنسان',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const Text(
                  'محكمة السياني الإبتدائية',
                  style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تطبيق إدارة قلم التوثيق',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF006400)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'بوابة الأمين الشرعي',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF006400)),
                ),
                const SizedBox(height: 48),
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'رقم الجوال',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الجوال';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006400),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('تسجيل الدخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
