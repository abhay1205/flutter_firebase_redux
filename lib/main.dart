import 'package:flutter/material.dart';
import 'package:reduxLoginStruct/models/appState.dart';
import 'package:reduxLoginStruct/pages/HomePage.dart';
import 'package:reduxLoginStruct/pages/SignInPage.dart';
import 'package:reduxLoginStruct/pages/SignUpPage.dart';
import 'package:reduxLoginStruct/redux/reducer.dart';
import 'package:reduxLoginStruct/redux/actions.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({this.store});
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: SignInPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(
            onInit: (){
              // dispatch an action
              StoreProvider.of<AppState>(context).dispatch(getUserAction);
            }
          ),
          '/SigninPage': (BuildContext context)=> SignInPage(),
          '/SignupPage': (BuildContext context)=> SignUpPage()
        },
      ),
    );
  }
}
