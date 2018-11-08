import 'dart:async';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/page/homeDrawer.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _IndexState();
  }
}
class _IndexState extends State<Index> {

  @override
  void initState() {
    super.initState();
  }
  
  Future<Null> pressSearch() {}
  
  
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        drawer: new HomeDrawer(),
        appBar: PreferredSize(
          child: new AppBar(
            leading: new Container(
              child: IconButton(
                padding: EdgeInsets.all(3.0),
                icon: Icon(Icons.menu),
               onPressed: () => Scaffold.of(context).openDrawer(),
               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            )),
            title: new Text("主页"),
            backgroundColor: AppTheme.main_color,
          ),
          preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.06),
        ),
        body: new Center(
            child: new ListView(
          children: <Widget>[
            new Row(children: <Widget>[
              new Text("当前批次：20180110"),
            ]),
            new Row(
              children: <Widget>[
                new Text("待拣订单数：500"),
                new Text("待拣产品数：2000"),
              ],
            ),
          ],
        )),
    );
  }
}
/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;
  TimeSeriesSales(this.time, this.sales);
}
