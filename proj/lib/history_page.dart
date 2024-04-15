import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime today = DateTime.now(); // Declare today variable

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
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
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set the color of the back button to white
          onPressed: () {
            Navigator.of(context).pop(); // Implement your navigation logic here
          },
        ),
      ),
      body: Content(onDaySelected: _onDaySelected, today: today),
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key? key, required this.onDaySelected, required this.today})
      : super(key: key);

  final Function(DateTime, DateTime) onDaySelected;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Health Status On ${today.toString().split(" ")[0]}"),
        Container(
          child: TableCalendar(
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: onDaySelected,
          ),
        ),
        // Add your other widgets here
      ],
    );
  }
}