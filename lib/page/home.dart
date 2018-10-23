import 'dart:async';
import 'package:chyy_app/page/index.dart';
import 'package:flutter/material.dart';
import 'package:chyy_app/page/AlarmPage.dart';
import 'package:chyy_app/page/Monitor.dart';
import 'package:chyy_app/page/homeDrawer.dart';
import 'package:chyy_app/widget/TabBarWidget.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/page/PickHome.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomePage extends StatelessWidget {
  static final String pName = "home";

  /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          content: new Text("确定要退出应用？"),
          actions: <Widget>[
            new FlatButton(onPressed: () => Navigator.of(context).pop(false), child: new Text("取消")),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text("确定"))
          ],
        ));
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2160)..init(context);
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new TabBarWidget(
        drawer: new HomeDrawer(),
        type: TabBarWidget.BOTTOM_TAB,
        tabItems: [
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Icon(Icons.home), new Text("主页",textScaleFactor: 1.0)],
            ),
          ),
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Icon(Icons.list), new Text("拣货",textScaleFactor: 1.0,)],
            ),
          ),
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Icon(Icons.print), new Text("出库",textScaleFactor: 1.0,)],
            ),
          ),
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Icon(Icons.search), new Text("查询",textScaleFactor: 1.0,)],
            ),
          ),
        ],
        tabViews: [
          new Index(),
          new PickHome(),
          new Index(),
          new Index(),
        ],
        backgroundColor: AppTheme.background_color,
        indicatorColor: Colors.white,
        title: new Text(""),
      ),
    );
  }
}

