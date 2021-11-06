import 'package:flutter/material.dart';

class TopText extends StatelessWidget {
  const TopText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: Colors.pink,
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
