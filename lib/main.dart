import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData.light(),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String input = "";

  createTodos() {
    DocumentReference documentReference =
        Firestore.instance.collection("MyTodos").document(input);

    Map<String, String> todos = {"todoTitle": input};

    documentReference.setData(todos).whenComplete(() {
      print("Done");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        Firestore.instance.collection("MyTodos").document(item);

    documentReference.delete().whenComplete(() {
      print("Deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Color(0xFF757575),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              'Add Task',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextField(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              cursorColor: Colors.blueAccent,
                              onChanged: (newText) {
                                input = newText;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            FlatButton(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              color: Colors.lightBlueAccent,
                              onPressed: () {
                                createTodos();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 35.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Todoey',
                    style: TextStyle(
                      fontFamily: 'Pacifino',
                      color: Colors.white,
                      fontSize: 55.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Made with',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20.0,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: StreamBuilder(
                  stream: Firestore.instance.collection("MyTodos").snapshots(),
                  builder: (context, snapshots) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshots.data.documents[index];
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                            child: Card(
                              elevation: 5.0,
                              child: ListTile(
                                title: Text(documentSnapshot["todoTitle"]),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    deleteTodos(documentSnapshot["todoTitle"]);
                                  },
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
