import 'package:flutter/material.dart';
import 'package:proj/components/my_textfield.dart';
import 'package:proj/history_page.dart';

class FitCheck extends StatelessWidget {
  FitCheck({super.key});

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fit check', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0), // Adjust the padding as needed
            child: IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                // Add your history functionality here


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
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
            const UserAccountsDrawerHeader(
              accountName: Text('John Doe'), // Replace with user's name
              accountEmail: Text('johndoe@example.com'), // Replace with user's email
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person), // Display an icon or your user's initials
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
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
                double height = double.tryParse(heightController.text) ?? 0;
                double weight = double.tryParse(weightController.text) ?? 0;
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
}



  