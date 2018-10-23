/*
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:chyy_app/utils/CommonUtils.dart';
import 'package:chyy_app/utils/NavigatorUtils.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:chyy_app/widget/LKTTabButton.dart';
import 'package:redux/redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcessMonitor extends StatefulWidget {
  final String id;
  final bool needBar;
  final String name;
  static final String pName = "ProcessMonitor";

  ProcessMonitor(this.id,this.needBar,this.name);
  @override
  State<StatefulWidget> createState() {
    return new _ProcessMonitorState();
  }

}


class _ProcessMonitorState extends State<ProcessMonitor>{

  showSuDeviceDialog(BuildContext context, String le) {
    le ??= "Null";
    showDialog(
        context: context,
        builder: (BuildContext context) =>AlertDialog(
            content:  new Text(le)
        ));
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  bool isDisposed = false;
  bool isShow = false;
  bool isLoading = false;
  int page = 1;
  List<Widget> tiles = [];
  List<Widget>  bottomWidgets =[];
  String imageUrl="https://linkortech.com/mes-yunmu/static/img/yunmu.ead51c0.png";

  var item = {
    "1" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5'},
    "2" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5'},
    "3" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5'},
    "4" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5'},
    "5" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5'},
    "6" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5','temp12':'模具温控6'},
    "7" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4','temp11':'模具温控5'},
    "8" : {'temp1':'机筒温控1','temp2':'机筒温控2','temp3':'机筒温控3','temp4':'机筒温控4','temp5':'机筒温控5','temp6':'合流芯温控','temp7':'模具温控1','temp8':'模具温控2','temp9':'模具温控3','temp10':'模具温控4',
      'temp11':'模具温控5','temp12':'模具温控6','temp13':'模具温控7','temp14':'模具温控8'},
    "9" : {'temp1':'热混温控','temp2':'冷混温控'},
  };
  _buildFeedColumn(data,name,value1,value2){
    return new GestureDetector(
      onTap: () {
       // showSuDeviceDialog(context, name);
         NavigatorUtils.goSubDevicePage(context,"feed",name,widget.id,data!=null?data["feed"]:null);
        },
          child: new Container(
            padding: EdgeInsets.all(1.0),
            decoration: new BoxDecoration(
                color:value2!="--"?AppTheme.main_color:Colors.grey,
                borderRadius: BorderRadius.circular(13.0),
                border: Border.all(color: Colors.grey, style: BorderStyle.solid)
             ),
              // width: ScreenUtil().setWidth(326),
               height: 100.0,
                child: new MaterialButton(onPressed: () {NavigatorUtils.goSubDevicePage(context,"feed",name,widget.id,data!=null?data["feed"]:null);},
                child: new Column(
                  children: <Widget>[
                    new Text(name,
                      textScaleFactor: 1.0,
                      style: new TextStyle(
                         fontSize: 16.0,
                          color:Colors.white
                      ),
                    ) ,
                    new Container(
                      padding: EdgeInsets.only(top:15.0),
                      child: new Row(
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new Container(
                                child: new Text("输出电流"+":",
                                  textScaleFactor: 1.0,
                                style: new TextStyle(color: Colors.white,
                                  fontSize: 15.0,
                                ),
                                ),
                              ),
                              new Text("输出转速"+":",
                                  textScaleFactor: 1.0,
                                  style: new TextStyle(color: Colors.white,
                                    fontSize: 15.0,
                                )),
                            ],
                          ),
                          new Column(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.only(bottom: 7.0),
                                child: new Text(value1,
                                    textScaleFactor: 1.0,
                                  style: new TextStyle(color: Colors.white,
                                    fontSize: 15.0,
                                  )),
                              ),
                              new Text(value2,
                                  textScaleFactor: 1.0,
                                  style: new TextStyle(color: Colors.white,
                                    fontSize: 15.0,
                                )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.all(2.0),
              ) ,
            ),
    );
  }
  _buildHostColumn(data,name,value1,value2){
    return new GestureDetector(
        onTap: () {
         NavigatorUtils.goSubDevicePage(context,"host",name,widget.id,data!=null?data["host"]:null);},
          child: new Container(
            padding: EdgeInsets.all(1.0),
            decoration: new BoxDecoration(
                color:value2!="--"?AppTheme.main_color:Colors.grey,
                borderRadius: BorderRadius.circular(13.0),
                border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid
                )),
            //width: 180.0,
            height: 100.0,
             // borderRadius: BorderRadius.circular(13.0),
             // shadowColor: Colors.grey.shade200,
              child:new MaterialButton(onPressed: () {NavigatorUtils.goSubDevicePage(context,"host",name,widget.id,data!=null?data["host"]:null);},
                  padding: EdgeInsets.all(2.0),
                  child: new Column(
                  children: <Widget>[
                  new Text(name,
                    textScaleFactor: 1.0,
                    style: new TextStyle(
                        fontSize: 16.0 ,
                        color: Colors.white
                    ),
                  ) ,
                  new Container(
                    padding: EdgeInsets.only(top:15.0),
                    child: new Row(
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text("输出电流"+":",
                                  textScaleFactor: 1.0,
                              style: new TextStyle( color: Colors.white,
                                fontSize: 14.0,
                              )
                              ),
                            ),
                            new Text("输出转速"+":",
                                textScaleFactor: 1.0,
                                style: new TextStyle( color: Colors.white,
                                fontSize: 14.0)
                            ),
                          ],
                        ),
                        new Column(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: new Text(value1,
                                  textScaleFactor: 1.0,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0)),
                            ),
                            new Text(value2,
                                textScaleFactor: 1.0,
                                style: new TextStyle( color: Colors.white,
                                  fontSize: 14.0)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
              ) ,
            //  color: AppTheme.main_color,
          ),

    );
  }
  _buildTowColumn(data,name,value1,value2){
    return  new GestureDetector(
        onTap: () {
         // showSuDeviceDialog(context, name);
          NavigatorUtils.goSubDevicePage(context,"tow",name,widget.id,data!=null?data["tow"]:null);
        },
          child: new Container(
            padding: EdgeInsets.all(1.0),
            decoration: new BoxDecoration(
                color:value2!="--"?AppTheme.main_color:Colors.grey,
                borderRadius: BorderRadius.circular(13.0),
                border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid
                )),
            //   width: 180.0,
            height: 100.0,
            child: new MaterialButton(onPressed: (){NavigatorUtils.goSubDevicePage(context,"tow",name,widget.id,data!=null?data["tow"]:null);}, padding: EdgeInsets.all(2.0),
            child:new Column(
              children: <Widget>[
                new Text(name,  textScaleFactor: 1.0,
                          style: new TextStyle(
                              fontSize: 16.0 ,
                              color: Colors.white
                          ),
                        ) ,
                new Container(
                          padding: EdgeInsets.only(top:15.0),
                          child: new Row(
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new Container(
                                    child: new Text("输出电流"+":",
                                      textScaleFactor: 1.0,
                                    style: new TextStyle(color: Colors.white,
                                      fontSize: 15.0 ,
                                    ),
                                    ),
                                  ),
                                  new Text("输出转速"+":",
                                      textScaleFactor: 1.0,
                                    style: new TextStyle(color: Colors.white,
                                      fontSize: 15.0 )),
                                ],
                              ),
                              new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.only(bottom: 7.0),
                                    child: new Text(value1,
                                        textScaleFactor: 1.0,
                                      style: new TextStyle(color: Colors.white,
                                        fontSize: 15.0  ,)),
                                  ),
                                  new Text(value2,
                                      textScaleFactor: 1.0,
                                    style: new TextStyle(color: Colors.white,
                                      fontSize: 15.0  ,)),
                                ],
                              )
                            ],
                          ),
                        )
              ],
            )),
          ),

    );
  }
  conBottomWidgets(data,key,_bottomWidgets) {
    if(data["children"]!=null){
       if(data["children"]['$key']!=null){
       var crt = data["children"]['$key']["crt_out"];
       var speed = data["children"]['$key']["speed_out"];
       if(key=="tow"){
          _bottomWidgets.add(_buildTowColumn(data["childrenMap"],"牵引",crt!=null?'$crt A':'--',speed!=null?'$speed r':'--'));
       }
       if(key=="host"){
         _bottomWidgets.add(_buildHostColumn(data["childrenMap"],"主机",crt!=null?'$crt A':'--',speed!=null?'$speed r':'--'));
       }
       if(key=="feed"){
          _bottomWidgets.add(_buildFeedColumn(data["childrenMap"],"喂料 ",crt!=null?'$crt A':'--',speed!=null?'$speed r':'--'));
        }
      }else{
         if(key=="tow"){
           _bottomWidgets.add(_buildTowColumn(data["childrenMap"],"牵引",'--','--'));
         }
         if(key=="host"){
           _bottomWidgets.add(_buildHostColumn(data["childrenMap"],"主机",'--','--'));
         }
         if(key=="feed"){
           _bottomWidgets.add(_buildFeedColumn(data["childrenMap"],"喂料 ",'--','--'));
         }
       }
    }else{
      if(key=="tow"){
        _bottomWidgets.add(_buildTowColumn(data["childrenMap"],"牵引",'--','--'));
      }
      if(key=="host"){
        _bottomWidgets.add(_buildHostColumn(data["childrenMap"],"主机",'--','--'));
      }
      if(key=="feed"){
        _bottomWidgets.add(_buildFeedColumn(data["childrenMap"],"喂料 ",'--','--'));
      }
    }
  }
  _subDevice(key,data,name,value){
    var dataMap;
    if(data["childrenMap"]!=null){
      dataMap =  data["childrenMap"][key];
    }
     var setVal =  0;
    if(data["children"]!=null){
      if(data["children"][key] !=null){
        setVal =  data["children"][key]["val_set"];
      }
    }
    Color color = Colors.green;
    Color fontColor = Colors.white;
    if(value!="--"){
      if(value-setVal>=10){
        color = Colors.red;
      }
      if(value - setVal<=10){
        color = Colors.yellow;
        fontColor = Colors.black;
      }
    }else{
        color = Colors.grey;
    }

    return new Material(
       borderRadius: BorderRadius.circular(13.0),
       shadowColor: color,
        color:color,
       elevation: 5.0,
        child:  new RaisedButton(
          color: color,
       onPressed: () {
        NavigatorUtils.goSubDevicePage(context,key,name,widget.id,dataMap);
       },
      child: new Container(
       width:  ScreenUtil().setWidth(220),
      //  height: ScreenUtil().setHeight(230),
        padding: EdgeInsets.only(top:1.0,bottom: 1.0),
       */
/* decoration: new BoxDecoration(
            color:color,
            border: Border.all(
                color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0))*//*

        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 13.0, left: 2.0, right: 2.0),
              child: new Text(name,
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 15.0, color: fontColor),
              ),
            ),
           new Container(
               padding: EdgeInsets.only(
                   bottom: 8.0),
            child:   new Text('$value ℃'
            ,    textScaleFactor: 1.0,style: TextStyle(fontSize: 15.0, color: fontColor) ,
            )
            )
          ],
        ),
      ),
    ));
  }
  checkItem(k,v,data,_tiles) {
    if (data != null) {
      if (data["childrenMap"]!= null) {
        if (data["childrenMap"]["_root"] != null) {
          var data2 = data["childrenMap"]["_root"] as List;
          for (var i = 0; i < data2.length; i++) {
            var data3 = data2[i] as Map;
            var key = data3["key"];
            if (key == k) {
              var value = data["children"][key]["val"];
              return _tiles.add(
                  _subDevice(k, data, data3["val"], value ?? "--"));
            }
          }
        }
      }
      _tiles.add(_subDevice(k,data,v,"--"));
    }
  //  print(k+v);
  }
  Future<Null> handleRefresh() async {
    var id = widget.id;
    if (isLoading) {
      return null;
    }
  //  print("id"+ id);
   //  isLoading = true;
     page = 1;
    List<Widget>  _tiles = [];
    List<Widget> _bottomWidgets = [];
    await  DeviceDao.getLastStatus(id).then((ret) {
      if (ret["result"] == 1) {
       // print(ret["result"]);
        tiles = [];
        item[id].forEach((k,v)=>checkItem(k,v,ret["data"]["record"]["extend"],_tiles));
        if(id != "9"){
          conBottomWidgets(ret["data"]["record"]["extend"],"tow",_bottomWidgets);
          conBottomWidgets(ret["data"]["record"]["extend"],"host",_bottomWidgets);
          conBottomWidgets(ret["data"]["record"]["extend"],"feed",_bottomWidgets);
        }
      }
      if (ret["result"] == 0) {
        // NavigatorUtils.goLogin(context);
        handleRefresh();
      }
      if(ret["result"] == -1){
        ToastUtils.errMsg(ret["message"]);
      }
    });
    if (this.mounted){
      setState(() {
        tiles = _tiles;
        bottomWidgets = _bottomWidgets;
      });
    }
    isLoading = false;
    return null;
  }
  Widget _buildEmpty() {
    return new Container(
      padding: EdgeInsets.all(150.0),
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: new Image(image: new AssetImage(AppICons.DEFAULT_USER_ICON), width: 70.0, height: 70.0),
          ),
          Container(
            child: Text("", style: AppConstant.normalText),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
  //  handleRefresh();
    super.initState();
  }
    showRefreshLoading() {
    new Future.delayed(const Duration(milliseconds:0 ), () {
      _refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }
  @override
  void didChangeDependencies() {
    if (tiles.length == 0) {
      setState(() {

      });
      showRefreshLoading();
    }
   // _topPartRow();
    super.didChangeDependencies();
  }
  Widget buildBottom(){
    //bottomWidgets.add(new Text("aa"));
    return
      new Container(
        padding: EdgeInsets.only(top:15.0, bottom: 10.0,left: 3.0,right: 3.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomWidgets
        ) ,
      );
  }
  _topPartRow() {
    if(widget.id=="9"){
    imageUrl = "https://linkortech.com/mes-yunmu/static/img/yunmu2.175a77c.png";
    }
    return  new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Expanded(
                child:new Image(image: new CachedNetworkImageProvider(imageUrl))
               */
/* new CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: new CircularProgressIndicator(),
                  errorWidget: new Icon(Icons.error),
                ),*//*

//                new Image.network(imageUrl,
//               //   width: 280.0,height: 200.0,
//                )
              */
/* new Image.asset('static/images/sheeben.png',
                width: 280.0,height: 200.0,
              )*//*

            ),
          ]
      );
  }
  buildSubDevice(){
    return   new Container(
      padding: EdgeInsets.only(top: 20.0,left: 5.0,right: 5.0,bottom: 0.0),
      color: AppTheme.background_color,
      child:new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        decoration: new BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 1.0),
            border: Border.all(
                color: Colors.grey, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8.0)),
        child: new Wrap(
          alignment: WrapAlignment.start,
          spacing: 6.0, // 水平方向上两个子组件的间距
          runSpacing: 20.0,
          children: tiles,
        ),
      ) ,
    );
  }
  Widget buildGrid() {

    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    if(tiles.length==0){
      content = _buildEmpty();
    //  return content;
     // tiles.add(new Text(""));
    }
    content = new ListView(
      children: <Widget>[
        buildSubDevice(),
        _topPartRow(),
        buildBottom(),
      ],
    );
    return content;
  }

  @override
  void dispose(){
    super.dispose();
    isDisposed = true;
  }
  @override
  Widget build(BuildContext context)  {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);

    var id = widget.id;
  //var titleName = '$id 号线详情';
    var titleName = widget.name;
    if(id=="9"){
      titleName = "混料机详情";
    }
  if (widget.needBar){
    return new Scaffold(
      backgroundColor: AppTheme.background_color,
      appBar: new AppBar(
        title: new Text(titleName),
        backgroundColor:  AppTheme.main_color,
      ),
      body:new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: handleRefresh,
        child:  buildGrid(),
      ),
    );
  }else{
    return new Scaffold(
      backgroundColor: AppTheme.background_color,

      body:new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: handleRefresh,
        child:  buildGrid(),
      ),
    );
  }

  }

}




*/
