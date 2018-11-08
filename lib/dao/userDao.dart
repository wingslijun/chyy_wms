import 'dart:convert';

import 'package:chyy_app/common/model/User.dart';
import 'package:chyy_app/common/redux/UserReducer.dart';
import 'package:chyy_app/utils/httpUtils.dart';
import 'package:chyy_app/utils/localstorage.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserDao {

  static final keyUser = "user";
  static Map user;

  static getUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(user!=null) return user;
    String userJson = await prefs.get(keyUser);
    if(userJson==null) return null;
    user = json.decode(userJson);
    return user;
  }

  static saveUser(Map user0) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(user!=null){
      user = user0;
      await prefs.setString(keyUser, json.encode(user0));
    }
  }

  static login(userName, password, store) async {
    await LocalStorage.save("username",userName);
    var verVal = "";
    try {
      var response = await HttpUtils.get("/user/auth/login");
      Document document = parser.parse(response.data);
      for (Element element in document.getElementsByTagName('input')) {
        if (element.attributes["name"] == "__RequestVerificationToken") {
          verVal = element.attributes["value"];
          break;
        }
      };
      return await HttpUtils.postLogin("/user/auth/login", {
        "username": userName,
        "password": password,
        "__RequestVerificationToken": verVal
      });
    } catch (e) {
      return {
        "result": -1,
        "message": "$e"
      };
    }
  }
  static clearAll(Store store) async {
  //  LocalStorage.remove(keyUser);
    store.dispatch(new UpdateUserAction(User.empty()));
  }

}

