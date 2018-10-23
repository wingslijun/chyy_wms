import 'dart:convert';

import 'package:chyy_app/common/config/Config.dart';
import 'package:chyy_app/common/model/Picking.dart';
import 'package:chyy_app/common/model/User.dart';
import 'package:chyy_app/common/redux/PickingReducer.dart';
import 'package:chyy_app/common/redux/UserReducer.dart';
import 'package:chyy_app/dao/DaoResult.dart';
import 'package:chyy_app/utils/httpUtils.dart';
import 'package:chyy_app/utils/localstorage.dart';
import 'package:redux/redux.dart';

class PickingDao {
  static Map pickings;

  static listPickings(Store store) async {
    var res = await HttpUtils.postForm("/rest/monitor/picking/list", {"needPartNum": "true"});
    print(res["result"]);
    if (res != null && res["result"]!=0) {
      List<Picking> list = new List();
      var listData = res["data"]["list"];
      if (listData == null || listData.length == 0) {
        return new DataResult(null, false);
      }

     /* List<SubPicking> suPickingList = new List();
      var sunPicking1 = getSubPicking("喂料","电流","10.0" ,"转速","10");
      var sunPicking2 = getSubPicking("主机","电流","10.0" ,"转速","10");
      var sunPicking3 = getSubPicking("牵引","电流","10" , "转速","10");
      suPickingList.add(sunPicking1);
      suPickingList.add(sunPicking2);
      suPickingList.add(sunPicking3);
      List<Picking> list = new List();
      Picking picking = new Picking("1号线", "1", "121",suPickingList);
      Picking picking2 = new Picking("2号线", "2", "121",suPickingList);
      Picking devic2 = new Picking("3号线", "2", "121",suPickingList);
      Picking devic4 = new Picking("4号线", "2", "121",suPickingList);
      list.add(picking);
      list.add(picking2);
      list.add(devic2);
      list.add(devic4);*/
      store.dispatch(new RefreshPickingAction(list));
      return new DataResult(list, true);
    } else {
     return new DataResult(null, false);
   }
  }

  static String formatTime(ms) {

    int mi = 60 * 1000;
    int hh = mi * 60;

    double hour =  (ms / hh);
    int hourFloor = hour.floor();
    double minute = (ms - hourFloor * hh) / mi;
    int minAfter = minute.toInt();
    double second = (ms - hourFloor * hh -minAfter * mi)/1000;
    String strHour = hourFloor < 10 ? "0" + hourFloor.toString() : "" + hourFloor.toString();//小时
    String strMinute = minAfter < 10 ? "0" + minAfter.toString() : "" + minAfter.toString();//分钟
    String strSecond = second.ceil() < 10 ? "0" + second.ceil().toString() : "" + second.ceil().toString();//秒

    return strHour+":"+ strMinute + ":" + strSecond ;
  }


}
