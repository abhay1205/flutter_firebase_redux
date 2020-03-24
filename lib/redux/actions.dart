import 'package:redux_thunk/redux_thunk.dart';
import 'package:reduxLoginStruct/models/appState.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThunkAction<AppState> getUserAction =  (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final List<dynamic> storedUser = prefs.getStringList('user');
  final String user = storedUser!=null? prefs.getString('email'): null;
  // print('actions page $storedUser, $user');
  store.dispatch(GetUserAction(user));
};

class GetUserAction{
  final dynamic _user;

  dynamic get user => this._user;

  GetUserAction(this._user);
}