import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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
              IconButton(
                  icon: const Icon(Icons.lightbulb),
                  onPressed: () async {
                    Get.isDarkMode
                        ? Get.changeTheme(ThemeData.light())
                        : Get.changeTheme(ThemeData.dark());
                  }),
            ]))));
  }
}
