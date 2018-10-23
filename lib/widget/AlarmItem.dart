import 'package:chyy_app/common/model/Alarm.dart';
import 'package:flutter/material.dart';

import 'package:chyy_app/common/style/theme.dart';

class AlarmItem extends StatelessWidget {
  final AlarmViewModel AlarmInfo;

  final VoidCallback onPressed;

  AlarmItem(this.AlarmInfo, {this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    Color color =Colors.blueGrey;
    if  (AlarmInfo.type=="normal"){
      color = Color.fromRGBO(255, 200, 0, 1.0);
    }
    if(AlarmInfo.type=="serious"){
      color = Color.fromRGBO(255, 0 ,0,1.0);
    }

    return new Container(
        color: AppTheme.background_color,
        padding: EdgeInsets.all(10.0),
        child: new Material(
          borderRadius: BorderRadius.circular(8.0),
          shadowColor: Colors.blue.shade200,
          elevation: 5.0,
          child:  new Container(
          color:Colors.white,
          padding: const EdgeInsets.all(26.0),
          child: new Row(
              children: [
                new Icon(
                  Icons.warning,
                  size:30.0,
                  color:color,
                ),
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(AlarmInfo.name,
                      textScaleFactor: 1.0,
                  style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          AlarmInfo.msg,
                          textScaleFactor: 1.0,
                          style: new TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class AlarmViewModel {
  String name;
  String type;
  String msg;
  AlarmViewModel();

  AlarmViewModel.fromMap(Alarm data) {
    name = data.name;
    type = data.type;
    msg = data.msg;
  }

  AlarmViewModel.fromTrendMap(model) {
    name = model.name;
    type = model.type;
    msg = model.msg;
  }
}


