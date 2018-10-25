import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:chyy_app/utils/CommonUtils.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';


class PickingItem extends StatefulWidget {
  final Picking pickingInfo;
  final VoidCallback onPressed;
  PickingItem(this.pickingInfo, {this.onPressed}) : super();
  @override
  State<StatefulWidget> createState() {
    return new _PickingItem();
  }

}
class _PickingItem extends State<PickingItem>{

  String barcode = "";


  Future scan(orderId,code,num) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      if(code==barcode){
        //查询已扫描数  需扫次数大于等于已扫时提醒否则增加已扫次数
        if(true){
          PickingDao.updateOrderProductNum(orderId,code,1).then((ret){
            widget.pickingInfo.subProducts.forEach((item){
              if(item.code == code) {
                setState(() {
                  item.areadyNum = item.areadyNum+1;
                });

              }
            });
          });
        }else{
          ToastUtils.normalMsg("此单此物已拣够。。");
        }
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }

  }
  Permission permission = Permission.Camera;

  requestPermission() async {
    final res = await SimplePermissions.requestPermission(permission);
    print("permission request result is " + res.toString());
  }

  checkPermission() async {
    bool res = await SimplePermissions.checkPermission(permission);
    print("permission is " + res.toString());
  }

  List<Widget> products;

  @override
  void didChangeDependencies() {
    _buildProductItem();
    super.didChangeDependencies();
  }


  List<Widget>  _buildProductItem(){
    List<Widget> _products;
    widget.pickingInfo.subProducts.forEach((item){
      _products.add(
        new Container(
          padding: EdgeInsets.only(top: 2.0,bottom: 2.0),
          child:Card(
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            child: new Text("H022-01"),
                            padding: EdgeInsets.only(
                                bottom: 2.0),
                          ),
                          new Image.asset(
                            "static/images/pic1.jpg",
                            width: 78.0,
                            height: 78.0,
                          )
                        ],
                      ),
                      padding: EdgeInsets.only(
                          left: 2.0,
                          right: 5.0,
                          bottom: 5.0),
                    ),
                    new Expanded(
                        child: new Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text("库位：${item.location}   " ),
                                new Text("条码：${item.code}")
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 2.0,bottom: 2.0),
                              child:new Text(
                                "${item.name}",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                              )
                              ,),
                            new Text("分类：${item.sku}"),
                            Container(
                                padding:EdgeInsets.only(top: 2.0,bottom: 2.0),
                                child:
                                new Row(
                                  children: <Widget>[
                                    new Text("X ${item.num}件") ,
                                    new  Expanded(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        new Container(
                                          child:  new Text("已拣：${item.areadyNum}件",style: TextStyle(
                                              color: Colors.white
                                          ),),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: Colors.pinkAccent,
                                              border:Border.all(color:Colors.pinkAccent,
                                                  width: 1.0)
                                          ),
                                        )
                                        ,
                                        new Container(
                                            height: 32.0,
                                            margin: EdgeInsets.only(left: 3.0,right: 6.0,bottom: 2.0),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(192,192,192,1.0),
                                              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                            ),
                                            child: new MaterialButton(
                                              padding: EdgeInsets.only(left: 4.0,right: 4.0),
                                              height: 10.0,
                                              minWidth: MediaQuery.of(context).size.width * 0.2,
                                              child: new Text("扫码拣货", textScaleFactor: 1.0,
                                                  style: new TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                scan(widget.pickingInfo.orderNum,item.code,item.num);
                                              },
                                            )
                                        )],
                                    ) ),
                                  ],
                                )


                            )
                          ],
                        )),
                  ],
                )
              ],
            ),
          ) ,
        ),
      );
    });
    setState(() {
      products =  _products;
    });
  }
  @override
  Widget build(BuildContext context) {
    var color;
    switch (widget.pickingInfo.status) {
      case "working":
        color = Colors.green;
        break;
      case "offline":
        color = Colors.grey;
        break;
      case "待拣货":
        color = Color.fromARGB(255, 230, 162, 60);
        break;
    }
    return new MaterialButton(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        onPressed: widget.onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: new Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: new BoxDecoration(
                color: AppTheme.background_color,
              ),
              child:new Card(child: new Container(
                padding: EdgeInsets.only(
                    left: 1.0, right: 1.0, top: 2.0, bottom: 2.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                    //订单信息
                    new Container(
                      child: new Card(
                        margin: EdgeInsets.all(3.0),
                        child:Column(
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "订单号：${widget.pickingInfo.orderNum}",
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
                                new Expanded(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Text("时间：${widget.pickingInfo.time}",
                                      style: AppConstant.middleTextBold,)
                                  ],))

                              ],
                            )
                          ],
                        ) ,
                      ),
                    ),
                    //订单产品
                    new Container(
                      child: Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(top: 2.0,bottom: 2.0),
                            child:Card(
                              child: new Column(
                                children: products,
//                                <Widget>[
//                                  new Row(
//                                    children: <Widget>[
//                                      new Container(
//                                        child: new Column(
//                                          children: <Widget>[
//                                            new Container(
//                                              child: new Text("H022-01"),
//                                              padding: EdgeInsets.only(
//                                                  bottom: 2.0),
//                                            ),
//                                            new Image.asset(
//                                              "static/images/pic1.jpg",
//                                              width: 78.0,
//                                              height: 78.0,
//                                            )
//                                          ],
//                                        ),
//                                        padding: EdgeInsets.only(
//                                            left: 2.0,
//                                            right: 5.0,
//                                            bottom: 5.0),
//                                      ),
//                                      new Expanded(
//                                          child: new Column(
//                                            crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              new Row(
//                                                children: <Widget>[
//                                                  new Text("库位：A0001  "),
//                                                  new Text("条码：6950885582563")
//                                                ],
//                                              ),
//                                              Container(
//                                                padding: EdgeInsets.only(top: 2.0,bottom: 2.0),
//                                                child:new Text(
//                                                  "CATHERINE MALANDRINO打底裤",
//                                                  softWrap: true,
//                                                  overflow: TextOverflow.ellipsis,
//                                                  maxLines: 3,
//                                                  textAlign: TextAlign.left,
//                                                )
//                                                ,),
//                                              new Text("分类：1黑+1灰;尺寸：L"),
//                                              Container(
//                                                  padding:EdgeInsets.only(top: 2.0,bottom: 2.0),
//                                                  child:
//                                                  new Row(
//                                                    children: <Widget>[
//                                                      new Text("X 3件") ,
//                                                      new  Expanded(child: Row(
//                                                        mainAxisAlignment: MainAxisAlignment.end,
//                                                        children: <Widget>[
//                                                          new Container(
//                                                            child:  new Text("已拣：2件",style: TextStyle(
//                                                                color: Colors.white
//                                                            ),),
//                                                            decoration: BoxDecoration(
//                                                                borderRadius: BorderRadius.circular(5.0),
//                                                                color: Colors.pinkAccent,
//                                                                border:Border.all(color:Colors.pinkAccent,
//                                                                    width: 1.0)
//                                                            ),
//                                                          )
//                                                          ,
//                                                          new Container(
//                                                              height: 32.0,
//                                                              margin: EdgeInsets.only(left: 3.0,right: 6.0,bottom: 2.0),
//                                                              decoration: BoxDecoration(
//                                                                color: Color.fromRGBO(192,192,192,1.0),
//                                                                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
//                                                              ),
//                                                              child: new MaterialButton(
//                                                                padding: EdgeInsets.only(left: 4.0,right: 4.0),
//                                                                height: 10.0,
//                                                                minWidth: MediaQuery.of(context).size.width * 0.2,
//                                                                child: new Text("扫码拣货", textScaleFactor: 1.0,
//                                                                    style: new TextStyle(color: Colors.white)),
//                                                                onPressed: () {
//                                                                  //scan(6950885582563);
//                                                                },
//                                                              )
//                                                          )],
//                                                      ) ),
//                                                    ],
//                                                  )
//
//
//                                              )
//                                            ],
//                                          )),
//                                    ],
//                                  )
//                                ],
                              ),
                            ) ,
                          ),
                        ],
                      ),
                    ),
                    //操作
                    new Container(
                        padding: EdgeInsets.only(
                            top: 8.0,
                            right: 8.0,bottom: 8.0),
                        child:
                        Row(
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(left: 2.0),
                              child:new Column(
                                children: <Widget>[
                                  new Text("拣货箱1：JH0001"),
                                  new Text("拣货箱2：JH0002")
                                ],
                              ) ,
                            ),
                            new Expanded(
                                child:
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Container(
                                        height: 40.0,
                                        margin: EdgeInsets.only(left: 3.0,right: 3.0),
                                        decoration: BoxDecoration(
                                          color: AppTheme.main_color,
                                          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                        ),
                                        child: new MaterialButton(
                                          padding: EdgeInsets.only(left: 4.0,right: 4.0),
                                          height: 10.0,
                                          minWidth: MediaQuery.of(context).size.width * 0.2,
                                          child: new Text("绑定拣货箱", textScaleFactor: 1.0,
                                              style: new TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed("home");
                                          },
                                        )
                                    ),
                                    new Container(
                                        height: 40.0,
                                        margin: EdgeInsets.only(left: 3.0,right: 3.0),
                                        decoration: BoxDecoration(
                                          color: AppTheme.Sure_Button,
                                          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                        ),
                                        child: new MaterialButton(
                                          height: 10.0,
                                          padding: EdgeInsets.only(left: 4.0,right: 4.0),
                                          minWidth: MediaQuery.of(context).size.width * 0.2,
                                          child: new Text("完成拣货", textScaleFactor: 1.0,
                                              style: new TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed("home");
                                          },
                                        )
                                    ),
                                  ],
                                )
                            )
                          ],
                        )

                    )
                  ],
                ),
              )
              ),
            ),
          ),
        ));
  }
}
