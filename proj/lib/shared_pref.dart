import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Viewer'),
      ),
      body: SharedPreferencesList(),
    );
  }
}

class SharedPreferencesList extends StatefulWidget {
  @override
  _SharedPreferencesListState createState() => _SharedPreferencesListState();
}

class _SharedPreferencesListState extends State<SharedPreferencesList> {
  List<String> sharedPreferencesKeys = [];
  Map<String, dynamic> sharedPreferencesData = {};

  @override
  void initState() {
    super.initState();
    _getAllSharedPreferences();
  }

  Future<void> _getAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferencesKeys = prefs.getKeys().toList();
      sharedPreferencesData = Map.fromIterable(sharedPreferencesKeys,
          key: (key) => key.toString(), value: (key) => prefs.get(key));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sharedPreferencesKeys.length,
      itemBuilder: (BuildContext context, int index) {
        final key = sharedPreferencesKeys[index];
        final value = sharedPreferencesData[key];
        return ListTile(
          title: Text(key),
          subtitle: Text(value.toString()),
        );
      },
    );
  }
}
