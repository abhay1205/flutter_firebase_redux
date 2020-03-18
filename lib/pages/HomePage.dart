import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:reduxLoginStruct/models/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final void Function() onInit;

  HomePage({this.onInit});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool issignedIn = false;

  checkAuth() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/SigninPage');
      }
    });
  }

  signout() async {
    _auth.signOut();
  }


  @override
  void initState() {
    super.initState();
    widget.onInit();
    this.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.orange,
              centerTitle: true,
              title: Text('Redux HomePage')),
          body: Center(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  backgroundImage: NetworkImage(''),
                  radius: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "\nYou are logged in as ${state.user.toString()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.orange,
                  onPressed: signout,
                  child: Text('Sign OUT', style: TextStyle(fontSize: 20)),
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
