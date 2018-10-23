import 'package:chyy_app/common/model/Alarm.dart';
import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/model/User.dart';
import 'package:chyy_app/common/redux/UserReducer.dart';
import 'package:chyy_app/common/redux/PickingReducer.dart';
import 'package:chyy_app/common/redux/AlarmReducer.dart';

class AppState {
  ///用户信息
  User userInfo;
  List<Picking> pickingList = new List();
  List<Alarm> alarmList;

  AppState({this.userInfo,this.pickingList,this.alarmList});
}
AppState appReducer(AppState state,action){

  return AppState(
      userInfo:  UserReducer(state.userInfo, action),
      pickingList: PickingReducer(state.pickingList, action),
      alarmList: AlarmReducer(state.alarmList,action),
  );
}


