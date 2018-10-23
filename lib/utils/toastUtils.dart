
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils{
  static normalMsg(String msg){
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
    );
  }

  static errMsg(String msg){
    // ??? todo
    print(123);
    Fluttertoast.showToast(
        msg: msg,
//        bgcolor:
        textcolor: '#ff0000'
    );
  }

  static chartMsg(String msg){
   Fluttertoast.showToast(
      msg: msg,
      gravity:  ToastGravity.BOTTOM,
      textcolor: "#275AA1",
      timeInSecForIos: 1,
      toastLength:Toast.LENGTH_SHORT
    );

  }


}