import 'package:chyy_app/page/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:chyy_app/page/ProcessMonitor.dart';
import 'package:chyy_app/page/ServiceInfo.dart';

import 'package:chyy_app/page/home.dart';
import 'package:chyy_app/page/login.dart';
import 'package:chyy_app/page/SubDevicePage.dart';

class NavigatorUtils {

  ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.pName);
  }

  //登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, Login.pName);
  }

  /**
   * 服务信息页
   */
  static getServiceInfo(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new ServiceInfo()));
  }

/*  static void goProcessMonitor(BuildContext context,id,name) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new ProcessMonitor(id,true,name)));
   // Navigator.pushReplacementNamed(context, ProcessMonitor.pName);
  }

  static void goSubDevicePage(BuildContext context,subKey,name,deviceId,data) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new SubDevicePage(subKey,name,deviceId,data)));
    // Navigator.pushReplacementNamed(context, ProcessMonitor.pName);
  }*/

  static void goOrderItemPage(BuildContext context,data) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new OrderItem(data)));
    // Navigator.pushReplacementNamed(context, ProcessMonitor.pName);
  }

}