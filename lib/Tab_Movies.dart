import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Movies extends StatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  State<Movies> createState() => _MoviesState();
}

TextEditingController _name =TextEditingController();
bool _watched=false;
final firebase = FirebaseFirestore.instance;

class _MoviesState extends State<Movies> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayBottomSheet(context);
        },
        child: Icon(Icons.add_comment_rounded),
          backgroundColor: Colors.orange.shade500,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: firebase.collection("Movies").orderBy("Name").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      QueryDocumentSnapshot data = snapshot.data!.docs[i];
                      return Column(
                        children: [
                          Row(
                              children: [
                                Checkbox(
                                  value: data['Watched'],
                                  onChanged: (b) {
                                    setState((){
                                      update(data['Name'],b!);
                                    });
                                  },
                                ),
                                Container(
                                  child: Card(
                                    color: Color.fromARGB(255, 245, 207, 168),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 260,
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            data['Name'],
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontFamily: 'Pacifico', fontWeight: FontWeight.bold, fontSize: 30),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Colors.grey.shade800,
                                          iconSize: 30,
                                          onPressed: () {
                                            setState((){
                                              delete(data['Name'],data['Watched'],context);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                  );
                }
                else {
                  return Center(child: CircularProgressIndicator());
                }
              }
              ),
        ),
      ),
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context){
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Add_Movie(),
          );
        }
    );
  }

  void delete(String name, bool watched, BuildContext context) {
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          'Are You Sure?',
          style: TextStyle(
            color: Color.fromARGB(255, 38, 23, 152),
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman Bold',
            fontSize: 28,
          ),
        ),
      ),
      content: Text(
        "Name : $name \nWatched : "+(watched ? "Yes" : "No"),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await firebase.collection("Movies").doc(name).delete();
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Delete"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 50, 44, 106)),
                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                },
              child: Text("Cancel"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 50, 44, 106)),
                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        )
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  void update(String name, bool watched) async{
    try {
      await firebase.collection("Movies").doc(name).update({"Watched": watched});
      print("done");
    } catch (e) {
      print(e);
    }
  }
}

class Add_Movie extends StatefulWidget {
  const Add_Movie({Key? key}) : super(key: key);

  @override
  State<Add_Movie> createState() => _Add_MovieState();
}

class _Add_MovieState extends State<Add_Movie> {
  String? _nameErrorText = null;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Add New Movie",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: 200,
                alignment: Alignment.center,
                child: Center(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: "Enter the Name of Movie",
                      border: UnderlineInputBorder(),
                      errorText: _nameErrorText,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Checkbox(
                value: _watched,
                onChanged: (bool? watch){
                  setState((){
                    _watched=watch!;
                  });
                },
              ),
              Text(
                _watched ? "Dekhliya" : "Nhi Dekha",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 10,
          ),
          Container(
            width: 250,
            child: ElevatedButton(
              onPressed:
                  () {
                setState((){
                  if(_name.text.isEmpty){
                    _nameErrorText="Name can't be empty.";
                  }
                  else{
                    _nameErrorText=null;
                    add(_name.text,_watched);
                    Navigator.pop(context);
                    _name.clear();_watched=false;
                  }
                });
              },
              child: Text("Save"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 50, 44, 106)),
                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void add(String name, bool watched) async{
    try {
      await firebase.collection("Movies").doc(name).set({"Name": name, "Watched": watched});
      print("added");
    } catch (e) {
      print(e);
    }
  }
}