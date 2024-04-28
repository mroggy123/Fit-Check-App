import 'package:flutter/material.dart';
import 'package:proj/components/my_textfield.dart';
import 'package:proj/history_page.dart';
import 'package:proj/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitCheck extends StatelessWidget {
  FitCheck({super.key});

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bpController = TextEditingController();

  Future<String> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ??
        ''; // Retrieve username from shared preferences
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for username retrieval, return a loading indicator
          return const CircularProgressIndicator();
        } else {
          // Once username is retrieved, display the fitcheck app page
          return Scaffold(
            appBar: AppBar(
              title: const Text('Fit check',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: IconButton(
                    icon: Icon(Icons.history),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: FutureBuilder(
                      future: _getUserName(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        } else {
                          return Text(snapshot.data ?? '');
                        }
                      },
                    ),
                    currentAccountPicture: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    accountEmail: null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyTextField(
                    controller: heightController,
                    hintText: 'Height(in cm)',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  MyTextField(
                    controller: weightController,
                    hintText: 'Weight(in kg)',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  MyTextField(
                    controller: bpController,
                    hintText: 'BP(in mmHg)',
                    obscureText: false,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      double height =
                          double.tryParse(heightController.text) ?? 0;
                      double weight =
                          double.tryParse(weightController.text) ?? 0;
                      int bp = int.tryParse(bpController.text) ?? 0;

                      // Calculate BMI
                      double bmi = weight / ((height / 100) * (height / 100));

                      // Check BMI category
                      String bmiCategory;
                      if (bmi < 18.5) {
                        bmiCategory = 'Underweight';
                      } else if (bmi >= 18.5 && bmi < 25) {
                        bmiCategory = 'Normal weight';
                      } else if (bmi >= 25 && bmi < 30) {
                        bmiCategory = 'Overweight';
                      } else {
                        bmiCategory = 'Obese';
                      }

                      // Check BP
                      String bpStatus;
                      if (bp < 120) {
                        bpStatus = 'Normal';
                      } else if (bp >= 120 && bp < 130) {
                        bpStatus = 'Elevated';
                      } else if (bp >= 130 && bp < 140) {
                        bpStatus = 'High Blood Pressure (Hypertension Stage 1)';
                      } else if (bp >= 140 && bp < 180) {
                        bpStatus = 'High Blood Pressure (Hypertension Stage 2)';
                      } else {
                        bpStatus = 'Hypertensive Crisis';
                      }

                      // Show result
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Fit Check Result'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('BMI: $bmiCategory'),
                                Text('Blood Pressure: $bpStatus'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
