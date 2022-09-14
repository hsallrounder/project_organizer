import 'package:cloud_firestore/cloud_firestore.dart';  // this is required to use firebase firestore instance.
import 'package:flutter/material.dart';

class Anime extends StatefulWidget {
  const Anime({Key? key}) : super(key: key);

  @override
  State<Anime> createState() => _AnimeState();
}

// We have declared these variables globally so that we can use this in bottom sheet down.
TextEditingController _name =TextEditingController();   // this controller will temporarily save the name which user will enter.
bool _watched=false;                                    // this will save the value that whether user have watched that anime or not
final firebase = FirebaseFirestore.instance;            // this is the instance which will help us connect to firebase

class _AnimeState extends State<Anime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(      // this button will display bottom sheet
        onPressed: () {
          displayBottomSheet(context);                 //here we created a function which will return the bottom sheet.
        },
        child: Icon(Icons.add_comment_rounded),
        backgroundColor: Colors.orange.shade500,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: firebase.collection("Anime").orderBy("Name").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      QueryDocumentSnapshot data = snapshot.data!.docs[i];      //here it is retrieving the data from databse
                      return Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(                       // this will display as store in database
                                value: data['Watched'],
                                onChanged: (b) {
                                  setState((){
                                    update(data['Name'],b!);   // also it will update data in database if clicked
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
                                          overflow: TextOverflow.ellipsis, // this will help us to take care if the name entered is too long to display
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
                                            delete(data['Name'],data['Watched'],context);             // here we created delete function to delete the data.
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
          ),
        ),
      ),
    );
  }
  void displayBottomSheet(BuildContext context) {       // here is that function which will return bottom sheet.
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context){
          return Padding(                                 // we used padding like this so that our sheet will move
            padding: EdgeInsets.only(                    // with our keyboard. lets see...
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Add_Anime(),
          );
        }
    );
  }

  void delete(String name, bool watched, BuildContext context) {                  // To delete the data
    var alertDialog = AlertDialog(                                              // Alert dialogue box
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
      content: Text(                               // It is displaying the data which we are going to delete
        "Name : $name \nWatched : "+(watched ? "Yes" : "No"),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(                         // Buttons used
              onPressed: () async {
                try {
                  await firebase.collection("Anime").doc(name).delete();             // first the data is deleted
                  Navigator.pop(context);                                           // then the alert dialogue box get away
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
                Navigator.pop(context);              // here no delete action is performed when clicked on "Cancel"
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

    showDialog(                                  // this will further show our dialogue box
        context: context,                       // references: lectures
        builder: (context) {
          return alertDialog;
        });
  }

  void update(String name, bool watched) async{              // same as add function
    try {
      await firebase.collection("Anime").doc(name).update({"Watched": watched});          //but changing only bool value
      print("done");
    } catch (e) {
      print(e);
    }
  }
}

class Add_Anime extends StatefulWidget {                      // This is the page which will be displayed in bottom sheet
  const Add_Anime({Key? key}) : super(key: key);

  @override
  State<Add_Anime> createState() => _Add_AnimeState();
}

class _Add_AnimeState extends State<Add_Anime> {
  String? _nameErrorText = null;     // this the error message if user click on save button without giving any name.
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
              "Add New Anime",
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
                    controller: _name,          // controller to save data temporarily.
                    decoration: InputDecoration(
                      hintText: "Enter the Name of Anime",
                      border: UnderlineInputBorder(),
                      errorText: _nameErrorText,     // error text variable which will change when user click on save button without giving name.
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Checkbox(
                value: _watched,              // check string our globally initialized value
                onChanged: (bool? watch){
                  setState((){
                    _watched=watch!;                // it is changing our value of checkbox.
                  });
                },
              ),
              Text(
                _watched ? "Dekhliya" : "Nhi Dekha",             // this is additional
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 10,
          ),
          Container(
            width: 250,
            child: ElevatedButton(              // we used elevated button here
              onPressed:
                  () {
                setState((){
                  if(_name.text.isEmpty){                            // this is checking whether user entered any name or not.
                    _nameErrorText="Name can't be empty.";           // error will display if no name was entered
                  }
                  else{                                              // if user have entered the name then it will add the data to firebase.
                    _nameErrorText=null;                             // also error text will also removed here
                    add(_name.text,_watched);                        // this is the function which will add the data.
                    Navigator.pop(context);                          // this will takeaway the bottom sheet - as our job is done.
                    _name.clear();_watched=false;                    // this will clear the data held by _name, and remove the checkbox value
                  }
                });
              },
              child: Text("Save"),
              style: ButtonStyle(                        // this is our button style.
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
      await firebase.collection("Anime").doc(name).set({"Name": name, "Watched": watched});   // data added to frebase here
      print("added");
    } catch (e) {
      print(e);
    }
  }
}
