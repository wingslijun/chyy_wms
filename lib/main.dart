import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/model/User.dart';
import 'package:chyy_app/page/AlarmPage.dart';
import 'package:chyy_app/page/Monitor.dart';
import 'package:chyy_app/page/ProcessMonitor.dart';
import 'package:chyy_app/page/login.dart';
import 'package:chyy_app/page/home.dart';
import 'package:redux/redux.dart';
import 'package:chyy_app/common/redux/AppState.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  final store = new Store<AppState>(
      appReducer,
      initialState:
      new AppState(
          userInfo: User.empty(),
          pickingList:new List(),
          alarmList:new List(),
      )
  );
  MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: //new StoreBuilder<AppState>(builder: (context, store) {
        new MaterialApp(
            // 默认路由
            home: new Login(),
      //      debugShowMaterialGrid: true,
            theme: new ThemeData(
              primarySwatch:Colors.blue,
              primaryColor:Colors.blueAccent
            ),
            routes: <String, WidgetBuilder>{
              Login.pName: (BuildContext context) => new Login(),
              HomePage.pName: (BuildContext context) => new HomePage(),
            /*  ProcessMonitor.pName: (BuildContext context) => new ProcessMonitor("1",true,"1号挤出机"),
              MonitorPage.pName: (BuildContext context) => new MonitorPage(),
              AlarmPage.pName: (BuildContext context) => new AlarmPage(true),*/
          //  });
      }),
    );
  }
}
