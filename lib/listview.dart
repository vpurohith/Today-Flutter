import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:today/boxes.dart';
import 'package:today/event.dart';
import 'globals.dart' as globals;

class EventListView extends StatelessWidget {
  const EventListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String title;
    late String color = 'test';

    Color pickerColor = Color(0xff443a49);
    Color currentColor = Color(0xff443a49);

    void _onEventChange(index, title, color) {
      Box<Event> eventBox = Hive.box<Event>(HiveBoxes.event);
      eventBox.putAt(
          index,
          Event(
            title: title,
            color: color,
            realColor: pickerColor.value,
          ));
    }

    TextEditingController nameController = TextEditingController();
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
                          content: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                style: TextStyle(
                                    color: globals.darkMode
                                        ? Colors.black
                                        : Colors.white),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Change Event Name',
                                  labelStyle: TextStyle(
                                      color: globals.darkMode
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'Cancel'),
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'OK'),
                                title = nameController.text,
                                _onEventChange(index, title, color),
                                nameController.clear(),
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
                        color: Color(res!.realColor!),
                        child: Center(
                          child: Text(res.title),
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
