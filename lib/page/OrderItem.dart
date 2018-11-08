import 'dart:async';
import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chyy_app/common/config/Config.dart';
import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:chyy_app/page/homeDrawer.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:flutter/services.dart';

class OrderItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with
        AutomaticKeepAliveClientMixin<OrderItem>,
        SingleTickerProviderStateMixin {
  Picking pickingInfo;
  String barcode = "";

  static const EventChannel _status_channel =
      const EventChannel('chyy_scanner_plugin.barcode');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    List<SubProduct> suProductList = new List();
    var sunPicking = new SubProduct(
        "H021-01",
        "粉水400毫升（赠品套装随机）",
        "lancome 兰蔻粉水买正装送小样礼盒水买正装送小样水买正装送小样",
        "A0001",
        "6950885582563",
        "imgurl",
        1,
        0);
    var sunPicking1 = new SubProduct(
        "H021-01",
        "555毫升（赠品套装随机）",
        "矿泉水",
        "A0001",
        "6901285991219",
        "imgurl",
        1,
        0);
    suProductList.add(sunPicking);
    suProductList.add(sunPicking1);
    pickingInfo = new Picking("20180101", "175789153536285600",
        "2018-02-16 21:07:25", "未拣货", suProductList);
    _status_channel
        .receiveBroadcastStream()
        .listen(_onGetCode, onError: _onGetCodeError);
  }

  var _jhbarcode = "";

  void _onGetCode(Object event) {
    setState(() {
      for (var i = 0; i < pickingInfo.subProducts.length; i++) {
        var productCode = pickingInfo.subProducts[i].code;
        if(productCode == event){
          pickingInfo.subProducts[i].areadyNum =  pickingInfo.subProducts[i].areadyNum+1;
        }
      }

      _jhbarcode = event;
    });
  }

  void _onGetCodeError(Object event) {
    print(event);
  }

  //扫描周转箱
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
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
        margin: EdgeInsets.all(2.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  child: new Column(
                    children: <Widget>[
                      new Image.asset(
                        "static/images/pic1.jpg",
                        width: 90.0,
                        height: 90.0,
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    var color = AppTheme.main_color;
    switch (this.pickingInfo.status) {
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
    return new StoreBuilder<AppState>(
      builder: (context, store) {
        return new Scaffold(
          drawer: new HomeDrawer(),
          appBar: PreferredSize(
              child: new AppBar(
                leading: new Container(
                    child: IconButton(
                  padding: EdgeInsets.all(3.0),
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                )),
                title: new Text(
                  "货物打包",
                ),
                backgroundColor: AppTheme.main_color,
              ),
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.06)),
          backgroundColor: AppTheme.background_color,
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: new Container(
                      padding: EdgeInsets.only(top: 2.0, bottom: 10.0),
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
                        child: SingleChildScrollView(
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
                                                      "单号：${this.pickingInfo.orderNum}",
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
                                                margin:
                                                    EdgeInsets.only(right: 5.0),
                                                padding: EdgeInsets.all(3.0),
                                                child: new Text(
                                                  "${pickingInfo.status}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: color)),
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
                                                style:
                                                    TextStyle(color: Colors.red),
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
                                  padding: EdgeInsets.all(2.0),
                                  child: new Column(
                                    children: _buildProductItem(),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(padding: EdgeInsets.all(2.0),child:new Text(
                                                  "拣货箱：$_jhbarcode",
                                                  style: AppConstant.middleTextActionWhiteBold,
                                                ) ,),
                                                Container(
                                                  margin: EdgeInsets.all(2.0),
                                                  child: new Text(
                                                    "${this.pickingInfo.time}",
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                      )
                  )
              )
          ),
        );
      },
    );
  }
}
