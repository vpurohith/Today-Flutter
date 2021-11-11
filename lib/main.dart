import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:today/boxes.dart';
import 'package:today/event.dart';

import './toptext.dart';
import './settingsbutton.dart';
import './listview.dart';
import 'globals.dart' as globals;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>(HiveBoxes.event);
  await Hive.openBox('darkModeBox');

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  globals.darkMode = savedThemeMode == AdaptiveThemeMode.light ? true : false;

  runApp(MaterialApp(
    home: MyApp(savedThemeMode: savedThemeMode),
  ));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

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

  late String title;
  late String color;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        home: Scaffold(
          body: ValueListenableBuilder(
              valueListenable: Hive.box<Event>(HiveBoxes.event).listenable(),
              builder: (context, box, widget) {
                return Column(
                  children: [
                    const SettingsButton(),
                    /*
                    SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: currentColor,
                        onColorChanged: changeColor,
                      ),
                    ), */
                    const TopText(),
                    EventListView(entries: entries, colorCodes: colorCodes)
                  ],
                );
              }),
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
                    backgroundColor:
                        globals.darkMode ? Colors.grey[0] : Colors.grey[800],
                    title: Text('Add a new event!',
                        style: TextStyle(
                            color: globals.darkMode
                                ? Colors.black
                                : Colors.white)),
                    content: TextField(
                      controller: nameController,
                      style: TextStyle(
                          color:
                              globals.darkMode ? Colors.black : Colors.white),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'New Event',
                        labelStyle: TextStyle(
                            color:
                                globals.darkMode ? Colors.black : Colors.white),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {
                          Navigator.pop(context, 'OK'),
                          title = nameController.text,
                          color = '200',
                          _onFormSubmit(),
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
      ),
    );
  }

  void _onFormSubmit() {
    Box<Event> eventBox = Hive.box<Event>(HiveBoxes.event);
    eventBox.add(Event(title: title, color: color));
  }
}
