import 'dart:async';
import 'dart:collection';

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
import 'package:chyy_app/widget/DeviceItem.dart';
import 'package:chyy_app/widget/LKTDeviceStateCard.dart';
import 'package:chyy_app/widget/LKTTabButton.dart';
import 'package:chyy_app/widget/LKTDeviceCard.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:redux/redux.dart';

class PickHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PickHomeState();
}
class _PickHomeState extends AppListState<PickHome> {

  _renderItem(e) {
    Picking picking = Picking.fromJson(e);
    return new DeviceItem(picking, onPressed: () {
    //  NavigatorUtils.goProcessMonitor(context,deviceViewModel.id,deviceViewModel.name);
    });
  }

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    await PickingDao.listPickings(_getStore());
    setState(() {
      pullLoadWidgetControl.needLoadMore = false;
    });
    isLoading = false;
    return null;
  }

  @override
  requestRefresh() async {
    return null;
  }

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  bool get isRefreshFirst => false;

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = _getStore().state.pickingList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      setState(() {
      });
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }
  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {

    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new StoreBuilder<AppState>(
      builder: (context, store) {
        return new Scaffold(
          backgroundColor: AppTheme.background_color,
          body: AppPullLoadWidget(
            pullLoadWidgetControl, (BuildContext context, int index) => _renderItem(pullLoadWidgetControl.dataList[index]),
            handleRefresh,
            onLoadMore,
            refreshKey: refreshIndicatorKey,
          ),
        );
      },
    );
  }
}