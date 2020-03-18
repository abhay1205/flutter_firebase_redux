import 'package:reduxLoginStruct/models/appState.dart';
import 'package:reduxLoginStruct/redux/actions.dart';

AppState appReducer(state, action) {
  return AppState(user: userReducer(state.user, action));
}

userReducer(user, action) {

  if(action is GetUserAction){
    return action.user;
  }
  return user;
}
