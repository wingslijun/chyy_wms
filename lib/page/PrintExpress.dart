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

class PrintExpress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PrintExpressState();
}

class _PrintExpressState extends State<PrintExpress>
    with AutomaticKeepAliveClientMixin<PrintExpress>, SingleTickerProviderStateMixin  {
  TabController _tabController;

  Picking pickingInfo;
  String barcode = "";
  List<Tab> myTabs = <Tab>[];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    List<SubProduct> suProductList = new List();
    var sunPicking = new SubProduct("--", "--",
        "--", "--", "--", "--", 0, 0);
     suProductList.add(sunPicking);
     pickingInfo = new Picking("--", "--", "--", "--", suProductList);
    _tabController = new TabController(vsync: this, length: myTabs.length);
  } //扫描周转箱
  Future scan(code) async {
    try {
      String barcode = await BarcodeScanner.scan();
      //根据条码查找订单;
      List<SubProduct> suProductList = new List();
      var sunPicking = new SubProduct("H021-01", "粉水400毫升（赠品套装随机）",
          "lancome 兰蔻粉水买正装送小样礼盒水买正装送小样水买正装送小样", "A0001", "6950885582563", "imgurl", 1, 0);
      suProductList.add(sunPicking);
      suProductList.add(sunPicking);
      Picking picking = new Picking("20180101", "175789153536285600",
          "2018-02-16 21:07:25", "未拣货", suProductList);
      setState(() {
        pickingInfo = picking;
        List<Tab> tabs = <Tab>[];
        for (var i = 0; i < pickingInfo.subProducts.length; i++) {
          var tab = new Tab(
              key: new ValueKey("$i"),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[new Text("产品${i + 1}")],
              ));
          tabs.add(tab);
        }
        myTabs = tabs;
        _tabController = new TabController(vsync: this, length: tabs.length);
      });
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

  @override
  bool get wantKeepAlive => true;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  Widget _buildPs(color){

    return new Center(
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
                                                margin: EdgeInsets.only(
                                                    right: 5.0),
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
                                              BorderRadius.circular(
                                                  2.0),
                                              border: Border.all(
                                                  color:
                                                  Colors.lightGreen,
                                                  width: 1.0)),
                                          child: new Text(
                                            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                                            softWrap: true,
                                            overflow: TextOverflow.fade,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.red),
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
                              height: 250.0,
                              padding: EdgeInsets.all(2.0),
                                child: new Scaffold(
                                  appBar: PreferredSize(
                                      child: new AppBar(
                                        //    backgroundColor: Colors.black,
                                        title: new TabBar(
                                            controller: _tabController,
                                            tabs: myTabs,
                                            isScrollable: true,
                                            indicatorColor: Colors.white
                                        ),
                                      ),
                                      preferredSize: Size.fromHeight(
                                          MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.05)),
                                  body: new TabBarView(
                                    controller: _tabController,
                                    children: myTabs.map((Tab tab) {
                                      var key = tab.key.toString();
                                      print(key.substring(
                                          3, key.length - 3));
                                      key = key.substring(
                                          3, key.length - 3);
                                      return _buildProduct(pickingInfo
                                          .subProducts[int.parse(key)]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                          new Container(
                              padding: EdgeInsets.only(
                                  top: 8.0, right: 8.0, bottom: 8.0),
                              child: Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                        margin:
                                        EdgeInsets.only(left: 2.0),
                                        child: new Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              "拣货箱：JH0ff001",
                                            ),
                                            Container(
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
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    var color =AppTheme.main_color ;
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
          appBar:  PreferredSize(child:  new AppBar(
            leading: new Container(
                child: IconButton(
                  padding: EdgeInsets.all(3.0),
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                )),
            title: new Text("货物打包",
            ),
            backgroundColor: AppTheme.main_color,
          ) , preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06)),
          backgroundColor: AppTheme.background_color,
          body: new ListView(
            children: <Widget>[
              new Container(
                child: new RaisedButton(
                    onPressed: () {
                      scan("a");
                    },
                    color: Colors.blue[400],

                      child: Center(
                        child: new Text('扫描拣货箱',
                            style: new TextStyle(color: Colors.white,fontSize: 18.0)),
                      ),
                ),
                margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                height: 50.0,
              ),
              new Container(
                 child: new Text("此箱对应订单及应有产品：",style: AppConstant.middleTextActionWhiteBold,),
                 margin: EdgeInsets.only(left: 3.0),
               ),
              _buildPs(color),
              new RaisedButton(
                onPressed: () {},
                child: new Text("确认物品"),
              )
            ],
          ),
        );
      },
    );
  }


}
