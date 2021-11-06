import 'package:flutter/material.dart';
import './settingsscreen.dart';

class SettingsButton extends StatefulWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsButtonState();
  }
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60.0, left: 300.0),
      child: IconButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.black,
          size: 35.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      ),
    );
  }
}
