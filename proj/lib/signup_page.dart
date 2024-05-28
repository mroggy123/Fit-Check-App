import 'package:flutter/material.dart';
import 'package:proj/components/my_textfield.dart';
import 'package:proj/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController user = TextEditingController();
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();

  Future<void> _signUp(BuildContext context) async {
    if (user.text.isEmpty || pass1.text.isEmpty || pass2.text.isEmpty) {
      // Either username or password fields are empty, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (pass1.text == pass2.text) {
      // Passwords match, proceed with registration
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', user.text);
      await prefs.setString('password', pass1.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign up successful'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Signup Page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // username textfield
                MyTextField(
                  controller: user,
                  hintText: 'email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: pass1,
                  hintText: 'enter password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: pass2,
                  hintText: 'confirm password',
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _signUp(context),
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
