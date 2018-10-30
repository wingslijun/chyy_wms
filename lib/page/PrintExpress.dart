import 'dart:async';
import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:chyy_app/common/config/Config.dart';
import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/page/homeDrawer.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:flutter/services.dart';

class PrintExpress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PrintExpressState();
}

class _PrintExpressState extends State<PrintExpress>
    with AutomaticKeepAliveClientMixin<PrintExpress> {

  Picking pickingInfo;

  String barcode = "";

  //扫描周转箱
  Future scan(code) async {
    try {
      String barcode = await BarcodeScanner.scan();
      //根据条码查找订单;
      if (code != barcode) {
        ToastUtils.errMsg("条码不符，请确认商品！");
      } else {
        for (var i = 0; i < this.pickingInfo.subProducts.length; i++) {
          var subProduct = this.pickingInfo.subProducts[i];
          if (subProduct.code == barcode) {
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
                scan(subProduct.code);
              }
              // });
              this.pickingInfo.subProducts[i] = subProduct;

            } else {
              ToastUtils.normalMsg("此单此物已拣够。。");
            }
            break;
          }
        }
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
  }

  //构造订单产品
  Widget _buildProduct(SubProduct item) {
    return new Container(
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Card(
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        child: new Text("H022-01"),
                        padding: EdgeInsets.only(bottom: 2.0),
                      ),
                      new Image.asset(
                        "static/images/pic1.jpg",
                        width: 78.0,
                        height: 78.0,
                      )
                    ],
                  ),
                  padding: EdgeInsets.only(left: 2.0, right: 5.0, bottom: 5.0),
                ),
                new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Text("库位：${item.location}   "),
                            new Text("条码：${item.code}")
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: new Text(
                            "${item.name}",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        new Text("分类：${item.sku}"),
                        Container(
                            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: new Row(
                              children: <Widget>[
                                //     new Text("X ${item.num}件"),
                                new Row(children: <Widget>[
                                  new Text("X "),
                                  new Text("${item.num}",style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0, color: Colors.red), ),
                                  new Text("件"),
                                ],),

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
                                                  color: Colors.green,
                                                  width: 1.0)),
                                        ),
                                        new Container(
                                            height: 32.0,
                                            margin: EdgeInsets.only(
                                                left: 3.0, right: 6.0, bottom: 2.0),
                                            decoration: BoxDecoration(
                                              color: Colors.pinkAccent,
                                              borderRadius: new BorderRadius.all(
                                                  new Radius.circular(10.0)),
                                            ),
                                            child: new MaterialButton(
                                              padding: EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              height: 10.0,
//                                              minWidth: MediaQuery.of(context).size.width * 0.2,
                                              child: new Text("扫码拣货",
                                                  textScaleFactor: 1.0,
                                                  style: new TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                scan(item.code);
                                              },
                                            ))
                                      ],
                                    )),
                              ],
                            ))
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
  List<Widget> _buildProductItem() {
    Picking picking = this.pickingInfo;
    List<Widget> _products = [];
    picking.subProducts.forEach((item) {
      _products.add(_buildProduct(item));
    });
    return _products;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new StoreBuilder<AppState>(
      builder: (context, store) {
        return new Scaffold(
          drawer: new HomeDrawer(),
          appBar: new AppBar(
            title: new Text("打印快递单"),
            backgroundColor: AppTheme.main_color,
          ),
          backgroundColor: AppTheme.background_color,
          body: new ListView(
            children: <Widget>[
              new RaisedButton(
                  onPressed: () {},
                  color: Colors.blue[400],
                  child: new Text(
                      '扫描拣货箱', style: new TextStyle(color: Colors.white)
                  )
              ),
              new Text("此箱中应有产品："),
              new Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: new BoxDecoration(
                      color: AppTheme.background_color,
                    ),
                    child: new Card(
                        child: new Container(
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
                                                      "订单号：${this.pickingInfo.orderNum}",
                                                      style: AppConstant
                                                          .middleTextBold,
                                                    ),
                                                  ],
                                                ),
                                                new Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      "批次：${this.pickingInfo.id}",
                                                      style: AppConstant
                                                          .middleTextBold,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          new Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  new Container(
                                                    margin: EdgeInsets.only(right: 5.0),
                                                    padding: EdgeInsets.all(3.0),
                                                    child: new Text(
                                                      "${pickingInfo.status}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    decoration: BoxDecoration(

                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                        border: Border.all(

                                                            width: 1.0)),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          new Text(
                                            "备注：",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                                "xxxxxxxx",
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
                              //订单产品
                              new Container(
                                child: Column(
                                  children: <Widget>[
                                    new Container(
                                      padding:
                                      EdgeInsets.only(top: 2.0, bottom: 2.0),
                                      child: Card(
                                        child: new Column(
                                          children: _buildProductItem(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //操作
                              new Container(
                                  padding: EdgeInsets.only(
                                      top: 8.0, right: 8.0, bottom: 8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.only(left: 2.0),
                                            child: new Column(
                                              children: <Widget>[
                                                new Text("拣货箱1：JH0001"),
                                                new Text("拣货箱2：JH0002")
                                              ],
                                            ),
                                          ),
                                          new Expanded(
                                              child: new Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  new Container(
                                                      height: 40.0,
                                                      margin: EdgeInsets.only(
                                                          left: 3.0, right: 3.0),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.main_color,
                                                        borderRadius: new BorderRadius
                                                            .all(
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

                                                        },
                                                      )),
                                                  new Container(
                                                      height: 40.0,
                                                      margin: EdgeInsets.only(
                                                          left: 3.0, right: 3.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: new BorderRadius
                                                            .all(
                                                            new Radius.circular(10.0)),
                                                      ),
                                                      child: new MaterialButton(
                                                        height: 10.0,
                                                        padding: EdgeInsets.only(
                                                            left: 4.0, right: 4.0),
                                                        minWidth: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                            0.2,
                                                        child: new Text(
                                                            "${pickingInfo.status != '完成拣货' ? '完成拣单' : '已完成拣单'}",
                                                            textScaleFactor: 1.0,
                                                            style: new TextStyle(
                                                                color: Colors.white)),
                                                        onPressed: () {

                                                        },
                                                      )),
                                                ],
                                              ))
                                        ],
                                      ),
//                            new Row(
//                              children: <Widget>[
//                                Container(
//                                  margin: EdgeInsets.all(3.0),
//                                  child: new Text(
//                                  "时间：${this.pickingInfo.time}",
//                                  style: AppConstant.middleTextBold,
//                                ),)
//
//                              ],
//                            )
                                    ],
                                  ))
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
