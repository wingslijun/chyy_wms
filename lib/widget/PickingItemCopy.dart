import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:chyy_app/utils/CommonUtils.dart';
import 'package:chyy_app/utils/NavigatorUtils.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class PickingItem extends StatefulWidget {
  final Picking pickingInfo;
  final ValueChanged<Picking> onChanged;

  PickingItem({Key key, @required this.pickingInfo, @required this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PickingItemState();
  }
}
  class _PickingItemState extends State<PickingItem>{
  String barcode = "";

  static const EventChannel _status_channel =
  const EventChannel('chyy_scanner_plugin.barcode');
  var _jhbarcode = "";

  StreamSubscription _barsubscription = null;

  @override
  void initState() {
    _barsubscription =   _status_channel
        .receiveBroadcastStream()
        .listen(_onGetCode, onError: _onGetCodeError);
  }
  void _disableBar() {
    if (_barsubscription != null) {
      _barsubscription.cancel();
      _barsubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
   // _disableBar();
  }
  bool containsCode = false;
  void _onGetCode(Object result) {
    print(result);
    var resultMap = result as Map;
    var bar524code = resultMap[524];
    var bar526code = resultMap[526];
    if(bar524code != null ){
      setState(() {
        for (var i = 0; i < widget.pickingInfo.subProducts.length; i++) {
          var subProduct = widget.pickingInfo.subProducts[i];
          if (subProduct.code == bar524code) {
            if (subProduct.areadyNum < subProduct.num) {
              //PickingDao.updateOrderProductNum(orderId,code,1).then((ret){
//              setState(() {
              subProduct = new SubProduct(
                  subProduct.id,
                  subProduct.sku,
                  subProduct.name,
                  subProduct.location,
                  subProduct.code,
                  subProduct.img,
                  subProduct.num,
                  subProduct.areadyNum + 1);
//              });
              if (subProduct.areadyNum < subProduct.num) {
                //  scan(subProduct.code);
              }
              // });
              widget.pickingInfo.subProducts[i] = subProduct;
              widget.onChanged(widget.pickingInfo);
            } else {
              ToastUtils.normalMsg("此单此物已拣够。。");
            }
            containsCode = true;
            break;
          }
        }
        if(!containsCode){
          ToastUtils.normalMsg("请注意！本单不包含此条码产品。");
        }
      });
    }
    List jhList = ['062107085205'];

    if(bar526code!=null){
      if(jhList.contains(bar526code)){
        if(widget.pickingInfo.jhBarCode == ""){
          widget.pickingInfo.jhBarCode = bar526code;
          widget.onChanged(widget.pickingInfo);
        }
      }else{
        ToastUtils.errMsg("此条码不是拣货箱条码");
      }
    }
  }

  void _onGetCodeError(Object event) {
    ToastUtils.errMsg(event);
  }
  //扫描
//  Future scan(code) async {
//    try {
//      String barcode = await BarcodeScanner.scan();
//      print('$code $barcode');
//      if (code != barcode) {
//        ToastUtils.errMsg("条码不符，请确认商品！");
//      } else {
//        for (var i = 0; i < widget.pickingInfo.subProducts.length; i++) {
//          var subProduct = widget.pickingInfo.subProducts[i];
//          if (subProduct.code == barcode) {
//            if (subProduct.areadyNum < subProduct.num) {
//              //PickingDao.updateOrderProductNum(orderId,code,1).then((ret){
////              setState(() {
//              subProduct = new SubProduct(
//                  subProduct.id,
//                  subProduct.sku,
//                  subProduct.name,
//                  subProduct.location,
//                  subProduct.code,
//                  subProduct.img,
//                  subProduct.num,
//                  subProduct.areadyNum + 1);
////              });
//              if (subProduct.areadyNum < subProduct.num) {
//                scan(subProduct.code);
//              }
//              // });
//              widget.pickingInfo.subProducts[i] = subProduct;
//              widget.onChanged(widget.pickingInfo);
//            } else {
//              ToastUtils.normalMsg("此单此物已拣够。。");
//            }
//            break;
//          }
//        }
//      }
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        this.barcode = 'The user did not grant the camera permission!';
//      } else {
//        this.barcode = 'Unknown error: $e';
//      }
//    } on FormatException {
//      this.barcode =
//          'null (User returned using the "back"-button before scanning anything. Result)';
//    } catch (e) {
//      this.barcode = 'Unknown error: $e';
//    }
//  }

  //扫描权限
  Permission permission = Permission.Camera;

  requestPermission() async {
    final res = await SimplePermissions.requestPermission(permission);
    print("permission request result is " + res.toString());
  }

  checkPermission() async {
    bool res = await SimplePermissions.checkPermission(permission);
    print("permission is " + res.toString());
  }

  //弹出确认框
  Future _confirmAlert(BuildContext context, List<SubProduct> s) {
    List<Widget> ws = [new Text("")];
    for (var i = 0; i < s.length; i++) {
      var p = s[i];
      Widget w =

      Container(
        margin: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: AppTheme.background_color,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text(
                  "条码： ${p.code}",
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                new Text(
                  "应拣: ${p.num}",
                  style: AppConstant.normalTextRedWhiteBold,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                new Text(
                  " 实拣: ${p.areadyNum} ",
                  style: AppConstant.normalTextRedWhiteBold,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ],
        ),
      );
      ws.add(w);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              contentPadding: EdgeInsets.all(2.0),
              titlePadding: EdgeInsets.all(0.5),
              title: Container(
                height: 40.0,
                  alignment: Alignment.centerLeft,
                  color: AppTheme.main_color,
                  child: new Text('确认部分拣货？' ,style: AppConstant.middleTextWhite,)),
                  content: new Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                child: new ListView(
                  children: ws,
                ),
              ),
              actions: <Widget>[
                new RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('取消')),
                new RaisedButton(
                    onPressed: () {
                      //减去相应的已拣货
                      widget.pickingInfo.status = "部分拣货";
                      widget.onChanged(widget.pickingInfo);
                      Navigator.of(context).pop();
                    },
                    child: new Text('确定')),
              ],
            ));
  }

  //绑定拣货箱
  Future _bindBox() async {
    try {
      String barcode = await BarcodeScanner.scan();
      //判断此周转箱是否有绑定订单 有的话不能绑定（打包时扫描周转箱，核对商品，打快递单，释放周转箱）
      var orderId = widget.pickingInfo.orderNum;
      if (true) {
        //insert(orderId,barcode)

        print("$orderId $barcode");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this.barcode = 'The user did not grant the camera permission!';
      } else {
        this.barcode = 'Unknown error: $e';
      }
    } on FormatException {
      this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
    }
    print(barcode);
  }

  //完成拣货
  Future _completePickOrder(BuildContext context) {
    //查看是否所有需捡商品数量 是否满足 （满足的话可以完成拣货，否则确认是否部分拣货）
    List<SubProduct> mes = new List();
    int num = widget.pickingInfo.subProducts.length;
    if (widget.pickingInfo.status == "已完成") {
      ToastUtils.normalMsg("此单已完成拣货,可送打包区。");
    } else {
      for (var i = 0; i < widget.pickingInfo.subProducts.length; i++) {
        var subProduct = widget.pickingInfo.subProducts[i];
        if (subProduct.areadyNum == 0) {
          num--;
        }
        if (subProduct.num != subProduct.areadyNum) {
          mes.add(subProduct);
        }
      }
      ;
      if (num == 0) {
        ToastUtils.normalMsg("未拣过商品，不能完成拣单！");
      } else {
        if (mes.length == 0) {
          //更改拣货单状态为已完成（刷新后从待拣货列表消失） dao
         widget. pickingInfo.status = "完成拣货";
         widget.onChanged(widget.pickingInfo);
        } else {
          //
          _confirmAlert(context, mes);
        }
      }
    }
  }

  //构造订单产品
  Widget _buildProduct(SubProduct item) {
    return new Container(
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Card(
        margin: EdgeInsets.all(2.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
//                      new CachedNetworkImage(
//                        width: 140.0,
//                        height: 110.0,
//                        fit: BoxFit.fitWidth,
//                          placeholder: new CircularProgressIndicator(),
//                         imageUrl: "${item.img}",
//                      ),
                      new Image.asset(
                        "static/images/pic1.jpg",
                        width: 140.0,
                        height: 110.0,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3.0),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      new Container(
//                        child: new Text("H022-01"),
//                        padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
//                      ),
                      Container(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: new Text("条码：${item.code}")),
                      new Container(
                        child: new Text("库位：${item.location}"),
                        padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(3.0),
                  child: new Text(
                    "品名: ${item.name}",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(3.0),
                    child: new Text("分类：${item.sku}")),
                new Container(
                    padding: EdgeInsets.only(left: 3.0, top: 8.0, right: 3.0),
                    child: new Row(
                      children: <Widget>[
                        // new Text("X ${item.num}件"),
                        new Row(
                          children: <Widget>[
                            new Text("数量：X "),
                            new Text(
                              "${item.num}",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.red),
                            ),
                            new Text("件"),
                          ],
                        ),
                        new Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                "已拣：${item.areadyNum}件",
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.green,
                                  border: Border.all(
                                      color: Colors.green, width: 1.0)),
                            ),
                            new Container(
                                height: 36.0,
                                margin: EdgeInsets.only(
                                    left: 3.0, right: 6.0, bottom: 2.0),
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10.0)),
                                ),
                                child: new MaterialButton(
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  height: 10.0,
//                                              minWidth: MediaQuery.of(context).size.width * 0.2,
                                  child: new Text("扫码拣货",
                                      textScaleFactor: 1.0,
                                      style:
                                          new TextStyle(color: Colors.white)),
                                  onPressed: () {
                                  //  scan(item.code);
                                  },
                                ))
                          ],
                        )),
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductItem() {
    Picking picking = widget.pickingInfo;
    List<Widget> _products = [];
    picking.subProducts.forEach((item) {
      _products.add(_buildProduct(item));
    });
    return _products;
  }

  @override
  Widget build(BuildContext context) {
    var color;
    switch (widget.pickingInfo.status) {
      case "部分拣货":
        color = Colors.orangeAccent;
        break;
      case "未拣货":
        color = AppTheme.main_color;
        break;
      case "完成拣货":
        color = Colors.green;
        break;
    }
    final List<Tab> myTabs = <Tab>[];
    for(var i=0;i<widget.pickingInfo.subProducts.length;i++){
      var tab = new Tab(
         key: new ValueKey("$i"),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[new Text("产品${i+1}")],
        )
      );
      myTabs.add(tab);
    }
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: new Container(
                padding: EdgeInsets.only(top: 2.0, bottom: 10.0),
                decoration: new BoxDecoration(
                  color: AppTheme.background_color,
                ),
                child: GestureDetector(
                  onTap:(){
                    //NavigatorUtils.goOrderItemPage(context, widget.pickingInfo);
                  },
                  child: new Card(
                      child: new Container(
                    padding: EdgeInsets.only(
                        left: 1.0, right: 1.0, top: 2.0, bottom: 2.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          child: new Card(
                            margin: EdgeInsets.all(3.0),
                            child: Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Text(
                                                "单号：${widget.pickingInfo.orderNum}",
                                                style: AppConstant.middleTextBold,
                                              ),
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              new Text(
                                                "批次：${widget.pickingInfo.id}",
                                                style: AppConstant.middleTextBold,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    new Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.only(right: 5.0),
                                          padding: EdgeInsets.all(3.0),
                                          child: new Text(
                                            "${widget.pickingInfo.status}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0, color: color)),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Text(
                                      "备注：",
                                      style: AppConstant.middleTextBold,
                                    ),
                                    new Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(2.0),
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            border: Border.all(
                                                color: Colors.lightGreen,
                                                width: 1.0)),
                                        child: new Text(
                                          "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        new Container(
                            width: 350.0,
                            height: 300.0,
                            padding: EdgeInsets.all(2.0),
                            child: new DefaultTabController(
                              length: myTabs.length,
                              child: new Scaffold(
                                appBar: PreferredSize(
                                    child: new AppBar(
                                      backgroundColor: Colors.green,
                                      title: new TabBar(
                                        tabs: myTabs,
                                        isScrollable: true,
                                        indicatorColor:Colors.white
                                      ),
                                    ),
                                    preferredSize: Size.fromHeight(
                                        MediaQuery.of(context).size.height *
                                            0.05)),
                                body: new TabBarView(
                                  children: myTabs.map((Tab tab) {
                                    var key = tab.key.toString();
                                    print(key.substring(3, key.length - 3));
                                    key = key.substring(3, key.length - 3);
                                    return _buildProduct(
                                        widget.pickingInfo.subProducts[int.parse(key)]);
                                  }).toList(),
                                ),
                              ),
                            )),
                        new Container(
                            padding: EdgeInsets.only(
                                top: 8.0, right: 8.0, bottom: 8.0),
                            child: Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.only(left: 2.0),
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text("拣货箱：${ widget.pickingInfo.jhBarCode}",
                                         ),
                                      Container(
                                    child: new Text(
                                    "${widget.pickingInfo.time}",

                                  ),)
                                        ],
                                      ),
                                    ),
                                    new Expanded(
                                        child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        new Container(
                                            height: 40.0,
                                            margin: EdgeInsets.only(
                                                left: 3.0, right: 3.0),
                                            decoration: BoxDecoration(
                                              color: AppTheme.main_color,
                                              borderRadius: new BorderRadius.all(
                                                  new Radius.circular(10.0)),
                                            ),
                                            child: new MaterialButton(
                                              padding: EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              height: 10.0,
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: new Text("绑定拣货箱",
                                                  textScaleFactor: 1.0,
                                                  style: new TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                _bindBox();
                                              },
                                            )),
                                        new Container(
                                            height: 40.0,
                                            margin: EdgeInsets.only(
                                                left: 3.0, right: 3.0),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius: new BorderRadius.all(
                                                  new Radius.circular(10.0)),
                                            ),
                                            child: new MaterialButton(
                                              padding: EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              height: 10.0,
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.2,
                                              child: new Text(
                                                  "${widget.pickingInfo.status != '完成拣货' ? '完成拣单' : '已完成拣单'}",
                                                  textScaleFactor: 1.0,
                                                  style: new TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                _completePickOrder(context);
                                              },
                                            )),
                                      ],
                                    ))
                                  ],
                                ),
                              ],
                            ))
                      ],
                    ),
                  )),
                ))));
  }
}
