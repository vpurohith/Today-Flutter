import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'globals.dart' as globals;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 300.0),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 35.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Text('Settings', style: TextStyle(fontSize: 30)),
            IconButton(
                icon: const Icon(Icons.lightbulb),
                onPressed: () async {
                  globals.darkMode = !globals.darkMode;
                  !globals.darkMode
                      ? AdaptiveTheme.of(context).setDark()
                      : AdaptiveTheme.of(context).setLight();
                }),
          ]),
        ),
      ),
    );
  }
}
