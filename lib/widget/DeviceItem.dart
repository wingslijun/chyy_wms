import 'package:chyy_app/common/model/Picking.dart';
import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';

class DeviceItem extends StatelessWidget {
  final Picking deviceInfo;
  final VoidCallback onPressed;
  DeviceItem(this.deviceInfo, {this.onPressed}) : super();

  _buildColumn(String name,String item1,String item1Value,String item2,String item2Value,){
    return  new Expanded(
     // width: 90.0,
      //  padding: EdgeInsets.all(2.0),
    //    decoration: new BoxDecoration(
      //    border: Border(left: BorderSide(color:Colors.grey,style: BorderStyle.solid ),right:BorderSide(color:Colors.grey,style: BorderStyle.solid ) ),
  //        ),
        
        child: new  Container(
          padding: EdgeInsets.all(1.0),
          decoration: new BoxDecoration(
            border: Border(left: BorderSide(color:Colors.grey,style: BorderStyle.solid ),right:BorderSide(color:Colors.grey,style: BorderStyle.solid )
          )),
        child:new Column(
        children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              padding:const EdgeInsets.only(top:2.0),
              child:new Text(name,
                textScaleFactor: 1.0,
                style: new TextStyle(
                    fontSize: 15.0,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ) ,
            )
          ],
        ),
        new Row(
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top:20.0,bottom: 2.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        alignment:Alignment.centerLeft ,
                        child: new Text(item1+":",
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      new Container(
                        padding:EdgeInsets.only(left: 0.0),
                        alignment:Alignment.centerLeft ,
                        child: new Text(item2+":",
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                )
              ],
            ),
            new Column(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top:20.0,bottom: 5.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.only(top:5.0, bottom: 5.0),
                        alignment:Alignment.centerLeft ,
                        child: new Text(item1Value,
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,),
                      ),
                      new Container(
                        padding:EdgeInsets.only(left: 0.0),
                        alignment:Alignment.centerLeft ,
                        child: new Text(item2Value,
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ],
    ) ,
        )
        /*child: new Column(
          
        children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              padding:const EdgeInsets.only(top:2.0),
              child:new Text(name,
                style: new TextStyle(
                    fontSize: 15.0
                ),
              ) ,
            )
          ],
        ),
        new Row(
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top:20.0,bottom: 2.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        alignment:Alignment.centerLeft ,
                        child: new Text(item1+":"),
                      ),
                      new Container(
                        padding:EdgeInsets.only(left: 0.0),
                        alignment:Alignment.centerLeft ,
                        child: new Text(item2+":"),
                      ),
                    ],
                  ),
                )
              ],
            ),
            new Column(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top:20.0,bottom: 5.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.only(top:5.0, bottom: 5.0),
                        alignment:Alignment.centerLeft ,
                        child: new Text(item1Value),
                      ),
                      new Container(
                        padding:EdgeInsets.only(left: 4.0),
                        alignment:Alignment.centerLeft ,
                        child: new Text(item2Value),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ],
    )*/);
  }

  @override
  Widget build(BuildContext context) {
    var  color;
    switch( deviceInfo.status){
      case "working":
        color = Colors.green;
        break;
      case "offline":
        color = Colors.grey;
        break;
      case "idle":
        color = Color.fromARGB(255,230,162,60);
        break;
    }
    return  new MaterialButton(
      onPressed: onPressed,
      child:new Container(
       padding: EdgeInsets.only(top:10.0,bottom: 10.0),
        decoration: new BoxDecoration(
          color: AppTheme.background_color,
        ),
          child: new Container(
            padding: EdgeInsets.only(left: 3.0,right: 3.0,top:2.0,bottom: 2.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: new Row(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(right: 3.0),
                        child: new Container(
                          //    width: 110.0,
                          //    color: color,
                          padding: EdgeInsets.only(left: 0.0,bottom: 12.0,top:10.0,right: 2.0),
                          decoration: new BoxDecoration(
                              color:color,
                              border: Border.all(
                                  color: Colors.grey, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(6.0)
                          ),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(deviceInfo.orderNum,
                                textScaleFactor: 1.0,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.only(top:16.0),
                                child: new Text(deviceInfo.time,
                                  textScaleFactor: 1.0,
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ) ,
                        ) ,
                      ),
                      new Expanded(
                          child:new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                            ],
                          )
                      )
                    ],
              ),
          //  ),
        )
          ),
    );
  }
}

/*class DeviceViewModel {
  String id;
  String name;
  String time;
  String status;
  List subDevices;
  DeviceViewModel();

  DeviceViewModel.fromMap(Device data) {
    id = data.id;
    name = data.name;
    time = data.time;
    status = data.status;
    subDevices = data.subDevices;
  }

  DeviceViewModel.fromTrendMap(model) {
    id = model.id;
    name = model.name;
    time = model.time;
    status = model.status;
    subDevices = model.subDevices;
  }
}*/


