import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  //Initializing firebase
  await Firebase.initializeApp(); //--------
  runApp(
      MaterialApp(
        home: HomePage(),        // this will return Home Page of our app
      )
  );
}