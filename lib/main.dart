import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  Color testColor = Colors.red;

  List<String> entries = <String>[];
  List<int> colorCodes = <int>[];

  void addItemToList() {
    setState(() {
      entries.insert(entries.length, nameController.text);
      colorCodes.insert(colorCodes.length, 200);
    });
  }

  /*
  Widget buildColorPicker() => BlockPicker(
        pickerColor: testColor,
        onColorChanged: (color) => setState(() => this.testColor = testColor),
      );

  void pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Pick Your Color'),
            content: Column(
              children: [
                buildColorPicker(),
                TextButton(
                  child: Text(
                    'SELECT',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            )),
      );
  */
  late String title;
  late String color;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            home: Scaffold(
              body: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Event>(HiveBoxes.event).listenable(),
                  builder: (context, box, widget) {
                    return Column(
                      children: [
                        const SettingsButton(),
                        /*
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 35.0,
                          ),
                          onPressed: () => pickColor(context),
                        ),
                        Column(
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: testColor,
                                ),
                                width: 120,
                                height: 120,
                              ),
                            ),
                          ],
                        ),*/
                        const TopText(),
                        EventListView(entries: entries, colorCodes: colorCodes)
                      ],
                    );
                  }),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
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
                        backgroundColor: globals.darkMode
                            ? Colors.grey[0]
                            : Colors.grey[800],
                        title: Text('Add a new event!',
                            style: TextStyle(
                                color: globals.darkMode
                                    ? Colors.black
                                    : Colors.white)),
                        content: TextField(
                          controller: nameController,
                          style: TextStyle(
                              color: globals.darkMode
                                  ? Colors.black
                                  : Colors.white),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'New Event',
                            labelStyle: TextStyle(
                                color: globals.darkMode
                                    ? Colors.black
                                    : Colors.white),
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
        ),
      ),
    );
  }

  void _onFormSubmit() {
    Box<Event> eventBox = Hive.box<Event>(HiveBoxes.event);
    eventBox.add(Event(title: title, color: color));
  }
}
