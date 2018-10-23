import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:chyy_app/common/style/theme.dart';


class CommonUtils {



  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            child: SpinKitDoubleBounce(color: Colors.blue[300])),
//                        new Container(height: 10.0),
//                        new Container(child: new Text(GSYStrings.loading_text, style: GSYConstant.normalTextWhite)),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }


///版本更新
//  static Future<Null> showUpdateDialog(BuildContext context, String contentMsg) {
//    return showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: new Text(GSYStrings.app_version_title),
//            content: new Text(contentMsg),
//            actions: <Widget>[
//              new FlatButton(
//                  onPressed: () {
//                    Navigator.pop(context);
//                  },
//                  child: new Text(GSYStrings.app_cancel)),
//              new FlatButton(
//                  onPressed: () {
//                    launch(Address.updateUrl);
//                    Navigator.pop(context);
//                  },
//                  child: new Text(GSYStrings.app_ok)),
//            ],
//          );
//        });
//  }
}
