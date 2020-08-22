import 'package:flutter/material.dart';
import 'database.dart';

class AddForm extends StatefulWidget {
  Map<String, dynamic> toEdit;

  AddForm(this.toEdit);

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> toEditR;
  String title = '';
  String description = '';

  @override
  void initState() {
    if (widget.toEdit == null) {
      widget.toEdit = {
        "_id": -420,
        "Title": ' ',
        "Description": ' ',
      };
    }
    toEditR = widget.toEdit;
    title = toEditR['Title'].toString();
    description = toEditR['Description'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff68b0ab),
      appBar: AppBar(
        backgroundColor: Color(0xff8fc0a9),
        title: Text(
          "Add/Edit To-do",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 45, 20),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    initialValue: toEditR['Title'].toString(),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "enter title here",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (String str) {
                      title = str;
                    },
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFormField(
                    initialValue: toEditR['Description'].toString(),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "enter description here",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (String str) {
                      description = str;
                    },
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Center(
                      child: RaisedButton(
                          child: Text('Add'),
                          color: Color(0xff8fc0a9),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (toEditR['_id'] == -420) {
                                int i = await DBHelper.instance.insert({
                                  DBHelper.columnTitle: title,
                                  DBHelper.columnDesc: description,
                                  DBHelper.timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                });
                              } else {
                                int id = await DBHelper.instance.update({
                                  DBHelper.columnId: toEditR['_id'],
                                  DBHelper.columnTitle: title,
                                  DBHelper.columnDesc: description,
                                  DBHelper.timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                });
                              }
                              Navigator.pop(context);
                            }
                          }))
                ],
              ),
            )),
      ),
    );
  }
}
