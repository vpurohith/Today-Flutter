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

  void _onFormSubmit() {
    Box<Event> eventBox = Hive.box<Event>(HiveBoxes.event);
    eventBox.add(Event(
      title: title,
      color: color,
      realColor: currColor.value,
    ));
  }

  late String title;
  late String color;
  late Color currColor = pickerColor;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light:
          ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ValueListenableBuilder(
              valueListenable: Hive.box<Event>(HiveBoxes.event).listenable(),
              builder: (context, box, widget) {
                return Column(
                  children: const [
                    SettingsButton(),
                    TopText(),
                    EventListView()
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
                    content: SingleChildScrollView(
                        // new line
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: Text('Choose the event color: ',
                                style: TextStyle(
                                    color: globals.darkMode
                                        ? Colors.black
                                        : Colors.white)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: BlockPicker(
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                      ],
                    )),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {
                          Navigator.pop(context, 'OK'),
                          title = nameController.text,
                          color = pickerColor.toString(),
                          currColor = pickerColor,
                          _onFormSubmit(),
                          nameController.clear(),
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
}
