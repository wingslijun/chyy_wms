import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';

class DeviceMonitorPage extends StatelessWidget {
  static final pName = "device_monitor";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _loginPanel(context)
    );
  }

  Widget _loginPanel(BuildContext context) {
    var loginBtn = new Material(
      borderRadius: BorderRadius.circular(32.0),
      shadowColor: AppTheme.main_color,
      elevation: 5.0,
      color: AppTheme.main_color,
      child: new MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        height: 42.0,
        onPressed: () {
          Navigator.of(context).pushNamed("login");
        },
        child: new Text('登  录'),
      ),
    );
    return new Center(
      child: new SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: new Card(
            // z轴高度，阴影大小
            elevation: 5.0,
            margin: EdgeInsets.all(20.0),
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('Deliver features faster'),
                new Text('Craft beautiful UIs'),
                new Expanded(child: new Text("haha")),
                loginBtn
//              new Expanded(
//                child: new FittedBox(
//                  fit: BoxFit.contain, // otherwise the logo will be tiny
//                  child: const FlutterLogo(),
//                ),
//              ),
              ],
            ),
          )
      ),

    );
  }

}