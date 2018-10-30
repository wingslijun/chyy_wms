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

  static listPickings(page,pageSize) async {
/*  var res = await HttpUtils.postForm("/rest/monitor/picking/list", {"needPartNum": "true"});
    print(res["result"]);
    if (res != null && res["result"]!=0) {
      List<Picking> list = new List();
      var listData = res["data"]["list"];
      if (listData == null || listData.length == 0) {
        return new DataResult(null, false);
      }
      store.dispatch(new RefreshPickingAction(list));
      return new DataResult(list, true);
    } else {
     return new DataResult(null, false);
   }*/
    List<Picking> list = new List();


      for(var i = 0;i<1;i++){
        List<SubProduct> suProductList = new List();
        List<SubProduct> suProductList2 = new List();
        var sunPicking1 = getSubProduct("H021-01","粉水400毫升（赠品套装随机）","lancome 兰蔻粉水买正装送小样礼盒","A0001","6950885582563","imgurl",1,0);
        var sunPicking2 = getSubProduct("H021-02","分类：2号;参考身高：8岁","娇韵诗白吸盘洗面奶200ml+爽肤水200ml套装爽肤水200ml套装","B0002","6922266445057","imgurl2",3,0);
        var sunPicking3 = getSubProduct("Hgsf-02","","爽肤水200ml","B0002","69226445057","imgurl2",3,1);
        suProductList.add(sunPicking1);
        suProductList.add(sunPicking2);
/*        suProductList2.add(sunPicking1);
        suProductList2.add(sunPicking2);*/
        Picking picking = new Picking("20180101","175789153536285600$i","2018-02-16 21:07:25","未拣货",suProductList);

        list.add(picking);

      }

      return new DataResult(list, true);
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

  static getSubProduct(String r,String s, String t, String u, String v, String w, x,int y) {
    return new SubProduct(r,s,t,u,v,w,x,y);
  }

  static updateOrderProductNum(orderId, code, int i) {}

 
}
