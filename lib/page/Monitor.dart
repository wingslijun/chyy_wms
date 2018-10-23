/*
import 'package:flutter/material.dart';
import 'package:chyy_app/page/ProcessMonitor.dart';

class MonitorPage extends StatelessWidget {
static final String pName = "MonitorPage";

final List<Tab> myTabs = <Tab>[
  new Tab(
    key: new ValueKey("1") ,

      child: new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Text("1号挤出机")],
  )),
  new Tab(key:new ValueKey("2") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("2号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("3") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("3号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("4") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("4号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("5") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("5号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("6") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("6号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("7") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("7号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("8") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("8号挤出机")],
  )
  ),
  new Tab(key:new ValueKey("9") , child:
  new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[new Text("混料机")],
  )
  ),
];

@override
Widget build(BuildContext context) {
  return new DefaultTabController(
    length: myTabs.length,
    child: new Scaffold(
      appBar: new AppBar(
        backgroundColor:  Color.fromARGB(255,100,149,237),
        title: new TabBar(

          tabs: myTabs,
          isScrollable: true,
        ),
      ),
      body: new TabBarView(
        children: myTabs.map((Tab tab) {
          var text = tab.key.toString();
        //  print(text.substring(3,text.length-3));
          text=text.substring(3,text.length-3);
          return  new ProcessMonitor('$text',false,tab.key.toString());
        }).toList(),
      ),
    ),
  );
}
}
*/
