import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj/fit_checking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime today = DateTime.now();
  List<FitCheckingData> hlist = [];
  List<FitCheckingData> filteredList = [];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      filteredList = hlist.where((data) => isSameDay(DateTime.parse(data.date), today)).toList();
    });
  }

  @override
  void initState() {
    getSharedPrefrences();
    super.initState();
  }

  Future<void> getSharedPrefrences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    readFromSp(sp);
  }

  void readFromSp(SharedPreferences sp) {
    List<String>? healthdata = sp.getStringList('myData');
    if (healthdata != null) {
      hlist = healthdata
          .map((contact) => FitCheckingData.fromJson(json.decode(contact)))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Table Calendar Example',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Content(onDaySelected: _onDaySelected, today: today, filteredList: filteredList),
    );
  }
}

class Content extends StatelessWidget {
  Content({
    super.key,
    required this.onDaySelected,
    required this.today,
    required this.filteredList,
  });

  final Function(DateTime, DateTime) onDaySelected;
  final DateTime today;
  final List<FitCheckingData> filteredList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10), // Adjust margin as needed
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black), // Border color
            borderRadius: BorderRadius.circular(10), // Border radius
          ),
          child: TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            selectedDayPredicate: (day) {
              return isSameDay(today, day);
            },
            onDaySelected: onDaySelected,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Date: ${filteredList[index].date.split(" ")[0]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Height: ${filteredList[index].height} cm"),
                    Text("Weight: ${filteredList[index].weight} kg"),
                    Text("BP: ${filteredList[index].bp} mmHg"),
                    Text("BMI: ${filteredList[index].bmiCategory}"),
                    Text("BP Status: ${filteredList[index].bpStatus}"),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
