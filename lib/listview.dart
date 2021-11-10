import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(36),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                entries.removeAt(index);
              },
              child: InkWell(
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('You`ve clicked on an event!'),
                      content: const Text('Add event options here',
                          style: TextStyle()),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {
                            Navigator.pop(context, 'OK'),
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  elevation: 3.0,
                  child: Container(
                    height: 50,
                    color: Colors.red[colorCodes[index]],
                    child: Center(
                      child: Text(entries[index]),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
