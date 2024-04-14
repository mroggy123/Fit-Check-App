import 'package:flutter/material.dart';
import 'package:proj/components/my_textfield.dart';
import 'package:proj/shared_pref.dart';
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
      return; // Exit the method without proceeding further
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
      // You might want to add more sophisticated error handling here
      // and provide feedback to the user if something goes wrong.
      // For simplicity, we're omitting that here.
    } else {
      // Passwords don't match, show an error message
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
                  obscureText: true, // Change to true for password field
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: pass2,
                  hintText: 'confirm password',
                  obscureText: true, // Change to true for password field
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _signUp(context),
                  child: const Text('Sign up'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SharedPreferencesViewer()),
                    );
                  },
                  child: const Text('View SharedPreferences Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}