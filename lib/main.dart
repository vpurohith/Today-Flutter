import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer';

import './toptext.dart';
import './settingsbutton.dart';

void main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();

  final listbase = openDatabase(
    join(await getDatabasesPath(), 'list_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE events(id INTEGER PRIMARY KEY, eventName TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertEvent(Event currEvent) async {
    // Get a reference to the database.
    final db = await listbase;

    // Insert the Event into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'events',
      currEvent.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> events() async {
    // Get a reference to the database.
    final db = await listbase;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('events');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        eventName: maps[i]['eventName'],
      );
    });
  }

  Future<void> updateEvent(Event event) async {
    // Get a reference to the database.
    final db = await listbase;

    // Update the given Dog.
    await db.update(
      'events',
      event.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(int id) async {
    // Get a reference to the database.
    final db = await listbase;

    // Remove the Dog from the database.
    await db.delete(
      'events',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  var testEvent = Event(
    id: 0,
    eventName: 'Drink Protein Powder',
  );

  await insertEvent(testEvent);

  print(events());

  testEvent = Event(
    id: testEvent.id,
    eventName: 'Drink Two Shakes of Protein Powder',
  );
  await updateEvent(testEvent);

  print(await events());

  await deleteEvent(testEvent.id);

  print(await events());
  */
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class Event {
  final int id;
  final String eventName;
  Event({
    required this.id,
    required this.eventName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
    };
  }

  @override
  String toString() {
    return 'Event{id: $id, eventName: $eventName}';
  }
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
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
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
        ));
  }
}

class EventListView extends StatelessWidget {
  const EventListView({
    Key? key,
    required this.entries,
    required this.colorCodes,
  }) : super(key: key);

  final List<String> entries;
  final List<int> colorCodes;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  elevation: 3.0,
                  child: Container(
                    height: 50,
                    color: Colors.red[colorCodes[index]],
                    child: Center(child: Text(entries[index])),
                  ));
            }));
  }
}
