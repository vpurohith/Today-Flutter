import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './toptext.dart';
import './settingsbutton.dart';
import './listview.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('testbox');

  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  TextEditingController nameController = TextEditingController();

  List<String> entries = <String>[];
  List<int> colorCodes = <int>[];

  void addItemToList() {
    setState(() {
      entries.insert(entries.length, nameController.text);
      colorCodes.insert(colorCodes.length, 200);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Column(
          children: [
            const SettingsButton(),
            const TopText(),
            EventListView(entries: entries, colorCodes: colorCodes)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 40.0,
            right: 40.0,
          ),
          child: FloatingActionButton(
            onPressed: () => {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Add a new event!'),
                  content: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Event',
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context, 'OK'),
                        addItemToList(),
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            },
            child: const Icon(
              Icons.add,
              size: 45.0,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 5,
          ),
        ),
      ),
    );
  }
}
