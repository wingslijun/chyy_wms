import 'dart:async';
import 'dart:collection';

import 'package:chyy_app/common/config/Config.dart';
import 'package:chyy_app/page/homeDrawer.dart';
import 'package:chyy_app/utils/CommonUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/page/Visiability.dart';
import 'package:chyy_app/test3.dart';
import 'package:chyy_app/utils/NavigatorUtils.dart';
import 'package:chyy_app/widget/AppListState.dart';
import 'package:chyy_app/widget/AppPullLoadWidget.dart';
import 'package:chyy_app/widget/PickingItem.dart';
import 'package:chyy_app/widget/LKTDeviceStateCard.dart';
import 'package:chyy_app/widget/LKTTabButton.dart';
import 'package:chyy_app/widget/LKTDeviceCard.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

class PickHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PickHomeState();
}
class _PickHomeState extends State<PickHome> with AutomaticKeepAliveClientMixin<PickHome>, AppListState<PickHome> {

  static TrendTypeModel selectTime = null;

  static TrendTypeModel selectType = null;
  _renderItem(index) {
    var picking = pullLoadWidgetControl.dataList[index];
    void _handleTapboxChanged(Picking newPicking) {
      setState(() {
        picking = newPicking;
      });
    }
    return new PickingItem(pickingInfo: picking,onChanged:_handleTapboxChanged,);
  }

  _getDataLogic() async {
    print("$page  ");
    return await PickingDao.listPickings(page,Config.PAGE_SIZE);
  }



  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => true;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }


  @override
  void didChangeDependencies() {
      setState(() {
        selectTime = trendTime(context)[0];
        selectType = trendType(context)[0];
      });
      showRefreshLoading();
      super.didChangeDependencies();
  }

  _renderHeader(Store<AppState> store) {
    if (selectType == null && selectType == null) {
      return Container();
    }
    return new Card(
      color: AppTheme.main_color,
      margin: EdgeInsets.all(10.0),
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: new Padding(
        padding: new EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
        child: new Row(
          children: <Widget>[
            _renderHeaderPopItem(selectTime.name, trendTime(context), (TrendTypeModel result) {
              if (isLoading) {
                Fluttertoast.showToast(msg: "加载中");
                return;
              }
              setState(() {
                selectTime = result;
              });
              showRefreshLoading();
            }),
            new Container(height: 10.0, width: 0.5,color: Colors.white,),
            _renderHeaderPopItem(selectType.name, trendType(context), (TrendTypeModel result) {
              if (isLoading) {
                Fluttertoast.showToast(msg:"加载中");
                return;
              }
              setState(() {
                selectType = result;
              });
              showRefreshLoading();
            }),
          ],
        ),
      ),
    );
  }

  _renderHeaderPopItem(String data, List<TrendTypeModel> list, PopupMenuItemSelected<TrendTypeModel> onSelected) {
    return new Expanded(
      child: new PopupMenuButton<TrendTypeModel>(
        child: new Center(child: new Text(data,style: AppConstant.middleTextWhiteBold,)),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return _renderHeaderPopItemChild(list);
        },
      ),
    );
  }

  _renderHeaderPopItemChild(List<TrendTypeModel> data) {
    List<PopupMenuEntry<TrendTypeModel>> list = new List();
    for (TrendTypeModel item in data) {
      list.add(PopupMenuItem<TrendTypeModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new StoreBuilder<AppState>(
      builder: (context, store) {
        return new Scaffold(
          appBar: PreferredSize(child:  new AppBar(
            leading: new Container(
                child: IconButton(
                  padding: EdgeInsets.all(3.0),
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                )),
            title: new Text("待拣货",
            ),
            backgroundColor: AppTheme.main_color,
          ) , preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06)),
          backgroundColor: AppTheme.background_color,
          body:AppPullLoadWidget(
              pullLoadWidgetControl, (BuildContext context, int index) => _renderItem(index),
              handleRefresh,
              onLoadMore,
              refreshKey: refreshIndicatorKey,
            ) ,
        );
      },
    );
  }
}
class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}

trendTime(BuildContext context) {
  return [
    new TrendTypeModel("全部", null),
    new TrendTypeModel("批次:2018101001GZ", "2018101001GZ"),
    new TrendTypeModel("批次:2018101001GZ", "2018101001GZ"),
    new TrendTypeModel("批次:2018101001GZ", "2018101001GZ"),
  ];
}

trendType(BuildContext context) {
  return [
    TrendTypeModel("全部", null),
    TrendTypeModel("未拣货", "1"),
    TrendTypeModel("部分拣货", "2"),
  ];
}