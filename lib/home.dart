import 'package:flutter/material.dart';
import 'package:todoapp/addtodo.dart';
import 'package:todoapp/database.dart';
import 'package:todoapp/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  int n;
  int index = 0;
  var sortedKeys;
  List<Map<String, dynamic>> todolist;
//async method which gets the data,
  get_list() async {
    return await DBHelper.instance.queryAll();
  }

  @override
  Widget build(BuildContext context) {
//fetching the neccessary data to diplay in ListTile from the local storage
    get_list().then((value) {
      todolist = value;

      todolist = todolist.reversed.toList();
      // after getting the data the loading screen is turned off
      setState(() {
        loading = false;
      });
    });
//diplay the main page as soon as the loading is false
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xff68b0ab),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xff8fc0a9),
                child: Icon(Icons.add),
                // go to add list screen if pressed
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddForm(null)));
                }),
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.info,
                  ),
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Info'),
                            content: Text(
                                'tap on the cards to know the upload date and time, tap on edit icon to edit the particular to_do\nonce deleted, we cant retrieve the data'),
                          );
                        });
                  }),
              backgroundColor: Color(0xff8fc0a9),
              title: Text(
                "To-do List",
                style: TextStyle(fontSize: 23, color: Color(0xfffaf3dd)),
              ),
              centerTitle: true,
            ),
            body: ListView.builder(
              itemCount: todolist.length,
              itemBuilder: (contex, index) {
                String dt = DateTime.fromMillisecondsSinceEpoch(
                        todolist[index]['Timestamp'])
                    .toString();

                return Card(
                  color: Color(0xfffaf3dd),
                  margin: EdgeInsets.fromLTRB(10, 6, 10, 5),
                  child: ListTile(
                    onTap: () {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('uploaded/edited on'),
                              content: Text(dt.substring(0, dt.length - 7)),
                            );
                          });
                    },
                    leading: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          int x = await DBHelper.instance
                              .delete(todolist[index]['_id']);
                        }),
                    title: Text(todolist[index]['Title']),
                    subtitle: Text(todolist[index]['Description']),
                    trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddForm(todolist[index])));
                        }),
                  ),
                );
              },
            ));
  }
}
