import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:redux/redux.dart';


/**
 * 服务信息
 */
class ServiceInfo extends StatefulWidget {
  static final pName = "ServiceInfo";

  @override
  State<StatefulWidget> createState() {
    return new _ServiceInfoState();
  }
}
class _ServiceInfoState extends State<ServiceInfo> {

  Align  buildText(IconData icon, String title, String label){
    return new Align(
      alignment:Alignment.bottomLeft ,
      child:new Container(
        color: AppTheme.background_color,
        padding: EdgeInsets.all(10.0),
        child: new Material(
          borderRadius: BorderRadius.circular(8.0),
          shadowColor: Colors.blue.shade200,
          elevation: 5.0,
          child:  new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.grey, style: BorderStyle.solid),
                   boxShadow: <BoxShadow>[
                          new BoxShadow (
                            color: Colors.grey,
                            offset: new Offset(0.0, 2.0),
                            blurRadius: 4.0,
                          ),
                          new BoxShadow (
                            color: Colors.grey,
                            offset: new Offset(0.0, 4.0),
                            blurRadius: 15.0,
                          )],
                borderRadius: BorderRadius.circular(8.0)),
            padding: const EdgeInsets.all(8.0),

            child: new Row(
              children: [
                new Icon(
                  icon,
                  size:30.0,
                  color: AppTheme.main_color,
                ),
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(title,
                    textScaleFactor: 1.0,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Container(
                   //     padding: const EdgeInsets.only(bottom: 6.0),
                        child: new Text(
                          label,
                          textScaleFactor: 1.0,
                          style: new TextStyle(
                            //  fontWeight: FontWeight.bold,
                              fontSize: 15.0
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: AppTheme.background_color,
      appBar: new AppBar(
        title: new Text('服务信息'),
        backgroundColor: AppTheme.main_color,
      ),
      body:new ListView(
          children: [
            new Container(
            padding: const EdgeInsets.all(30.0),
            child: new Column(
            children:<Widget>[ new Text("杭州领克信息技术有限公司", textScaleFactor: 1.0,
            style:  new TextStyle(
              color: AppTheme.main_color,
            fontWeight: FontWeight.bold,
            fontSize:24.0
                ),
             )],
             )
            ),
            new Container(
              padding: const EdgeInsets.all (20.0),
              alignment: Alignment.bottomLeft,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildText(Icons.business , "联系地址:","杭州经济技术开发区白杨街道6号大街452号2-D1810"),
                  buildText(Icons.call,"服务电话:","0571-56071258"),
                  buildText(Icons.people,"技术专员:","应"),
                  buildText(Icons.call,"专员电话:","0571-56071258"),
                  buildText(Icons.web,"公司网址:","www.lingkexinxi.com"),
                ],
              ),
            ),
           new Container(
              color: AppTheme.background_color,
              padding: EdgeInsets.all(10.0),
              child: new Material(
                borderRadius: BorderRadius.circular(8.0),
                shadowColor: Colors.blue.shade200,
                elevation: 5.0,
                child:  new Container(
              //    color:Colors.white,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey, style: BorderStyle.solid),
                      boxShadow: <BoxShadow>[
                        new BoxShadow (
                          color: Colors.grey,
                          offset: new Offset(0.0, 2.0),
                          blurRadius: 4.0,
                        ),
                        new BoxShadow (
                          color: Colors.grey,
                          offset: new Offset(0.0, 4.0),
                          blurRadius: 15.0,
                        )],
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.all(16.0),
                  child: new Row(
                    children: [
                      new Icon(
                        Icons.call,
                        size:30.0,
                        color:AppTheme.main_color,
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                '技术支持：0571-56071258 ',
                                textScaleFactor: 1.0,
                                style: new TextStyle(
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
            )


        ],
      )
    );
  }

} /* Container(
padding: const EdgeInsets.all(15.0),
alignment: Alignment.bottomLeft,
color: Colors.white,
child: new Row(
mainAxisSize: MainAxisSize.min,
children: <Widget>[
new Icon(Icons.call,
color: Theme.of(context).primaryColor,
size: 35.0,
),
new Container(
padding: const EdgeInsets.only(left: 15.0),
child: new Text('技术支持：0571-56071258 ',
style: new TextStyle(fontSize: 23.0),
softWrap: true,
overflow: TextOverflow.ellipsis,
maxLines: 2,
textAlign: TextAlign.left,
)
)
],
)
)*/