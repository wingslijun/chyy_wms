import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/dao/AlarmDao.dart';
import 'package:chyy_app/widget/AlarmItem.dart';
import 'package:chyy_app/widget/AppListState.dart';
import 'package:chyy_app/widget/AppPullLoadWidget.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:redux/redux.dart';


class AlarmPage extends StatefulWidget {
  static final String pName = "AlarmPage";
  final bool needBar;
  AlarmPage(this.needBar);
  @override
  State<StatefulWidget> createState() {
    return new _AlarmPageState();
  }
}
class _AlarmPageState extends AppListState<AlarmPage>{

  static const AndroidNotificationChannel channel = const AndroidNotificationChannel(
    id: 'default_notification11',
    name: 'CustomNotificationChannel',
    description: 'Grant this app the ability to show notifications',
    importance: AndroidNotificationChannelImportance.HIGH,
    vibratePattern: AndroidVibratePatterns.DEFAULT,
  );
  void removeNotify(String payload) async {
    await LocalNotifications.removeNotification(0);
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new AlarmPage(true)));
  }
  _getAddNotificationChannelButton() async {
    print("get channel");
    await LocalNotifications.createAndroidNotificationChannel(
        channel: channel);
  }
  _getBasicNotification(name,msg) async {
    await LocalNotifications.createNotification(
        id: 0,
        title: '警报信息',
        content: '$name $msg',
        androidSettings: new AndroidSettings(
          isOngoing: false,
          channel: channel,
          priority: AndroidNotificationPriority.HIGH,
        ),
        onNotificationClick: new NotificationAction(
            actionText: "some action",
            callback: removeNotify,
            payload: ""
        )
    );
  }
  int count =0;
  @override
  void initState() {
    /*  _getAddNotificationChannelButton();
     var timer = Timer.periodic(const Duration(seconds: 20), (Void) async{
       print("执行一次定时任务");
       await AlarmDao.listAlarms(_getStore());
       pullLoadWidgetControl.dataList = _getStore().state.alarmList;
       print(count);
       print(pullLoadWidgetControl.dataList.length);
       if(count<pullLoadWidgetControl.dataList.length && count !=0){
         var index = pullLoadWidgetControl.dataList.length-1;
         AlarmViewModel alarm = AlarmViewModel.fromMap(pullLoadWidgetControl.dataList[index]);
         _getBasicNotification(alarm.name, alarm.msg);
       }
       setState(() {
         count = pullLoadWidgetControl.dataList.length;
       });
    });
     ///定时2秒
     new Future.delayed(const Duration(seconds: 5), () {
       handleRefresh();
    });*/
  }

  _renderItem(e) {
    AlarmViewModel alarm = AlarmViewModel.fromMap(e);
    return new AlarmItem(alarm, onPressed: () {
    //  NavigatorUtils.goProcessMonitor(context,alarm);
    });
  }
  
  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
   // isLoading = true;
    page = 1;
    await AlarmDao.listAlarms(_getStore());
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
    pullLoadWidgetControl.dataList = _getStore().state.alarmList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }
  Store<AppState> _getStore() => StoreProvider.of(context);

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(widget.needBar){
      return new StoreBuilder<AppState>(
          builder: (context, store) {
            return new Scaffold(
              backgroundColor: AppTheme.background_color,
              appBar: new AppBar(
                title: new Text("设备警告"),
                backgroundColor:  AppTheme.main_color,
              ),
              body: AppPullLoadWidget(
                pullLoadWidgetControl,
                    (BuildContext context, int index) => _renderItem(pullLoadWidgetControl.dataList[index]),
                handleRefresh,
                onLoadMore,
                refreshKey: refreshIndicatorKey,
              ),
            );
          }
      );
    }else{
      return new StoreBuilder<AppState>(
          builder: (context, store) {
            return new Scaffold(
              backgroundColor: AppTheme.background_color,
              body: AppPullLoadWidget(
                pullLoadWidgetControl,
                    (BuildContext context, int index) => _renderItem(pullLoadWidgetControl.dataList[index]),
                handleRefresh,
                onLoadMore,
                refreshKey: refreshIndicatorKey,
              ),
            );
          }
      );
    }

  }

}