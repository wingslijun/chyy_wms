import 'dart:async';
import 'package:chyy_app/common/model/Alarm.dart';
import 'package:chyy_app/common/redux/AlarmReducer.dart';
import 'package:chyy_app/dao/DaoResult.dart';
import 'package:chyy_app/utils/httpUtils.dart';
import 'package:redux/redux.dart';
class AlarmDao {
  static listAlarms(Store store) async {
    var res = await HttpUtils.postForm(
        "/rest/monitor/device/alarms", {"needPartNum": "true"});
    if (res != null && res["result"] != 0 && res["data"]!=null ) {
      List<Alarm> list = new List();

      var listData = res["data"]["alarms"];
      if (listData == null || listData.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < listData.length; i++) {
        Alarm model = Alarm.empty();
        model.name = listData[i]["device"]["name"];
        model.type = listData[i]["type"];
        model.msg = listData[i]["msg"];
        list.add(model);
      }
//      var timer = Timer.periodic(const Duration(seconds: 20), (Void) async{
//        print("添加一条警报");
//        list.add(new Alarm("1号挤出机", "normal", "一般警报"));
//        store.dispatch(new RefreshAlarmAction(list));
//      });
      store.dispatch(new RefreshAlarmAction(list));
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }
}