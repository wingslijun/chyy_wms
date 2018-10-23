import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';

class LKTDeviceCard extends StatefulWidget {
  final Map deviceInfo;
  LKTDeviceCard(this.deviceInfo);
  @override
  State<StatefulWidget> createState() => new _LKTDeviceCardState(this.deviceInfo);
}
class _LKTDeviceCardState extends State<LKTDeviceCard> {
  Map deviceInfo;
  _LKTDeviceCardState(this.deviceInfo);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(
        bottom: 5.0
      ),
      padding: EdgeInsets.all(3.0),
      height: 90.0,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: AppTheme.white
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Image(
                image: new AssetImage(deviceInfo["url"]),
                width: 67.0,
                height: 67.0,
              ),
              new Text(deviceInfo["name"], style: new TextStyle(color: AppTheme.main_color))
            ],
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(bottom: 29.0),
                child: new Text("机床型号: ${deviceInfo["model"]}", style: new TextStyle(fontSize: AppTheme.small_font)),
              ),
              new Text("加工件数: ", style: new TextStyle(fontSize: AppTheme.big_font)),
              new Text("主轴倍率: 0   快速倍率: 0   进给倍率: 0", style: new TextStyle(fontSize: AppTheme.small_font))
            ],
          ),
          new MaterialButton(
            color: AppTheme.main_color,
            textColor: AppTheme.white,
            minWidth: 17.0,
            height: 30.0,
            onPressed: () => print("pressed"),
            child: new Text("运行"),
          )
        ],
      ),
    );
  }
}