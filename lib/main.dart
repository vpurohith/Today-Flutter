import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Today Calendar App',
        home: Scaffold(
          body: Column(
            children: [SettingsButton(), TopText()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(
              Icons.add,
              size: 45.0,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ));
  }
}

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
      margin: const EdgeInsets.only(top: 50.0, left: 300.0),
      child: IconButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.black,
          size: 35.0,
        ),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('This is the settings alert!'),
              content:
                  const Text('Change this onPressed to go to settings page!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TopText extends StatelessWidget {
  const TopText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('What do you want to do',
                    style: TextStyle(fontSize: 30)),
              ),
              Center(
                child: Text(
                  'Today?',
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(2, 2),
                            blurRadius: 3),
                      ]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
