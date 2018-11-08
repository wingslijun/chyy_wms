import 'package:chyy_app/utils/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/redux/UserReducer.dart';

import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/utils/CommonUtils.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:chyy_app/utils/NavigatorUtils.dart';
import 'package:chyy_app/widget/LKTIconInputWidget.dart';
import 'package:chyy_app/dao/userDao.dart';
import 'package:redux/redux.dart';
import 'package:chyy_app/common/model/User.dart';


class Login extends StatefulWidget {
  static final pName = "login";

  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<Login> {
  var _name, _pwd;
  final TextEditingController userController = new TextEditingController();

  @override
  void initState() {
    super.initState();
   _initParams();
  }

  _initParams() async {
    // todo
    _name = await await LocalStorage.get("username");
    userController.value = new TextEditingValue(text: _name ?? null);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2154)..init(context);
    return new StoreBuilder<AppState>(builder: (context, store) {
      return new Scaffold(
          backgroundColor: AppTheme.main_color,
          body: _loginPanel(context,store)
      );
    });
  }

  Widget _loginPanel(BuildContext context,Store store) {
    var _nameWidget = new LKTIconInputWidget(
      hintText: "用户名",
      iconData: Icons.account_circle,
      controller: userController,
      onChanged: (String val) {
        _name = val;
      },
    );
    var _pwdWidget = new LKTIconInputWidget(
      hintText: "密  码",
      obscureText: true,
      iconData: Icons.lock,
      onChanged: (String val) {
        _pwd = val;
      },
    );
    var loginBtn = new Material(
      borderRadius: BorderRadius.circular(32.0),
      shadowColor: AppTheme.main_color,
      elevation: 5.0,
      color: AppTheme.main_color,
      child: new MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        height: 42.0,
        onPressed: () {
         if (_name == null || _name.length == 0 || _pwd == null ||
              _pwd.length == 0) {
            ToastUtils.normalMsg("用户名或密码不能为空");
            return;
          }
          CommonUtils.showLoadingDialog(context);
          UserDao.login(_name, "A525626*", store).then((ret) {
            Navigator.pop(context);
            if (ret["result"] == 0 || ret["result"] == -1 ) {
              ToastUtils.normalMsg(ret["message"]);
            } else {
              User u = new User(-1,ret["user"]["username"]);
              store.dispatch(new UpdateUserAction(u));
              NavigatorUtils.goHome(context);
           }
         });
        },
        child: new Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(350),
          child:  new Text(
              '登  录',
              textScaleFactor: 1.0,
              style: new TextStyle(color: Colors.white, fontSize: 16.0)
          ) ,
        )

      ),
    );
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        new Image(image: new AssetImage("static/images/login_logo2.png"),
//            width: ScreenUtil().setWidth(330),
//            height: ScreenUtil().setHeight(330)),
        new Card(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          color: Colors.white,
          margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0),
          child: new Padding(
            padding: new EdgeInsets.only(
                left: 30.0, top: 13.0, right: 30.0, bottom: 20.0),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _nameWidget,
                  _pwdWidget,
                  SizedBox(height: 22.0),
                  loginBtn
                ]
            ),
          ),
        ),
      ],
    );
  }
}