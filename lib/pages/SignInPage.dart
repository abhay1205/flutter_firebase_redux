import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  checkAuth() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  navToSignInPage() {
    Navigator.of(context).pushReplacementNamed('/SigninPage');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  void sigin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: _email, password: _password))
          .user;
      List<String> userInfo = [
        user.email.toString(),
        user.displayName.toString(),
        user.getIdToken().toString(),
      ];
      _storeUserData(userInfo);
      if (user.email != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      ;
    } catch (e) {
      showError(e.message);
    }
  }

  Future<FirebaseUser> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final AuthResult authResult =
          await _auth.signInWithCredential(authCredential);
      final FirebaseUser user = authResult.user;

      assert(user.email != null);
      assert(user.displayName != null);

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentuser = await _auth.currentUser();
      assert(user.uid == currentuser.uid);
      List<String> userInfo = [
        user.email.toString(),
        user.displayName.toString(),
        user.getIdToken().toString(),
      ];
      _storeUserData(userInfo);
      if (user.email != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }

      return user;
    } catch (e) {
      showError(e.message);
    }
  }

  void _storeUserData(userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userInfo[0]);
    //prefs.setStringList('user', userInfo);
    // print('signIn page ${prefs.getString('email')}');
  }

  showError(String errMsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errMsg),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Log In'),
        centerTitle: true,
      ),
      body: Container(
          child: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
              child: Text("LOGIN",
                  style: TextStyle(fontSize: 30, color: Colors.orange)),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      //email
                      Container(
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                              value.contains('@') ? null : 'Invalid Email',
                          onSaved: (value) => _email = value,
                        ),
                      ),
                      // password
                      Container(
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          onSaved: (value) => _password = value,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: RaisedButton(
                            elevation: 5,
                            color: Colors.orange,
                            onPressed: sigin,
                            child: Text('Log In', style: TextStyle(fontSize: 20),),
                          )),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GoogleSignInButton(
                          text: 'Google Sign In',
                          darkMode: true,
                          onPressed: () {
                            _signInWithGoogle()
                                .then((FirebaseUser user) => print(user))
                                .catchError((e) => print(e));
                          },
                          borderRadius: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
