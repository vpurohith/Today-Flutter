import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:today/boxes.dart';
import 'package:today/event.dart';

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
      child: ValueListenableBuilder(
        valueListenable: Hive.box<Event>(HiveBoxes.event).listenable(),
        builder: (context, Box<Event> box, _) {
          return ListView.builder(
              padding: const EdgeInsets.all(32),
              itemCount: box.values.length,
              itemBuilder: (BuildContext context, int index) {
                Event? res = box.getAt(index);
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    res!.delete();
                  },
                  child: InkWell(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(res?.title ?? 'Error!'),
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
                        color: Colors.red[200],
                        child: Center(
                          child: Text(res!.title),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
