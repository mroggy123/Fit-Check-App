// fit_check.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj/changepass.dart';
import 'package:proj/components/my_textfield.dart';
import 'package:proj/fit_checking_model.dart';
import 'package:proj/history_page.dart';
import 'package:proj/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitCheck extends StatefulWidget {
  FitCheck({super.key});

  @override
  State<FitCheck> createState() => _FitCheckState();
}

class _FitCheckState extends State<FitCheck> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bpController = TextEditingController();

  List<FitCheckingData> healthdata = List.empty(growable: true);
  late SharedPreferences sp;

  @override
  void initState() {
    getSharedPrefrences();
    super.initState();
  }

  Future<void> getSharedPrefrences() async {
    sp = await SharedPreferences.getInstance();
    readFromSp();
  }

  void saveIntoSp() {
    List<String> contactListString =
        healthdata.map((contact) => jsonEncode(contact.toJson())).toList();
    sp.setStringList('myData', contactListString);
  }

  void readFromSp() {
    List<String>? hd = sp.getStringList('myData');
    if (hd != null) {
      healthdata = hd
          .map((contact) => FitCheckingData.fromJson(json.decode(contact)))
          .toList();
    }
    setState(() {});
  }

  Future<String> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
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
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
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

                      // Create new health data entry
                      FitCheckingData newData = FitCheckingData(
                        date: DateTime.now().toString(),
                        height: height,
                        weight: weight,
                        bp: bp,
                        bmi: bmi,
                        bmiCategory: bmiCategory,
                        bpStatus: bpStatus,
                      );

                      // Add to list and save
                      setState(() {
                        healthdata.add(newData);
                        saveIntoSp();
                      });

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
