import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';

class LKTDeviceStateCard extends StatelessWidget {
  final IconData icon;
  final String cardText;
  final int amount;
  final Color bgColor;
  LKTDeviceStateCard({this.icon, this.cardText, this.amount = 0, this.bgColor = AppTheme.white});
  @override
  Widget build(BuildContext context) => new Center(
      child: new Material(
          shadowColor: Color.fromRGBO(150, 150, 150, 0.5),
          elevation: 3.0,
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: new Container(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: new IconTheme(
                  data: new IconThemeData(color: AppTheme.white, size: 35.0),
                  child: new Column(
                      children: <Widget>[
                        new Container(width: 40.0, height: 50.0, child: new Icon(icon)),
                        new Container(height: 30.0, child: new Text(cardText, style: new TextStyle(color: AppTheme.white))),
                        new Text(amount.toString(), style: new TextStyle(color: AppTheme.white))
                      ]
                  )
              )
          )
      )
  );
}