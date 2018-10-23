import 'dart:convert';

import 'package:chyy_app/common/config/Config.dart';
import 'package:chyy_app/common/model/User.dart';
import 'package:chyy_app/common/redux/UserReducer.dart';
import 'package:chyy_app/dao/DaoResult.dart';
import 'package:chyy_app/utils/httpUtils.dart';
import 'package:chyy_app/utils/localstorage.dart';
import 'package:redux/redux.dart';

class UserDao {

  static final keyUser = "user";
  static Map user;

  static getUser() async{
    if(user!=null) return user;
    String userJson = await LocalStorage.get(keyUser);
    if(userJson==null) return null;
    user = json.decode(userJson);
    return user;
  }

  static saveUser(Map user0){
    if(user!=null){
      user = user0;
      LocalStorage.save(keyUser, json.encode(user0));
    }
  }

  static login(userName, password, store) async {
    return await  HttpUtils.postForm("/rest/user/loginByUsername", {
     "username":userName,
     "pwd":password
   });
  }
  static clearAll(Store store) async {
  //  LocalStorage.remove(keyUser);
    store.dispatch(new UpdateUserAction(User.empty()));
  }

}

