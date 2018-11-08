import 'package:chyy_app/utils/localstorage.dart';
import 'package:dio/dio.dart';
import 'package:chyy_app/common/config/server.dart';

class HttpUtils{
  static Options _options= new Options(
      baseUrl:ServerConfig.mesUrl,
      connectTimeout:10000,
      receiveTimeout:3000
  );

  static Dio dio = new Dio(_options);

  static postLogin(String url,var data) async{
    Response response;
    try {
      response = await dio.post(url,data:new FormData.from(data));
      print("resp ${response.statusCode}  $response ");
      if(response.statusCode ==200){
        return {
          "result":0,
          "message":"用户名或密码错误!"
        };
      }
     // return response.data;
    }on DioError catch (e) {
      print("eeeeee $e");
      if(e.response==null){
        return {
          "result":-1,
          "message":"网络异常"
        };
      }
      if(e.response.statusCode == 302){

        return {
          "result":1,
          "user":{"username":data["username"]}
        };
      }else{
        return {
          "result":-1,
          "message":"网络异常"
        };
      }
    }
  }
  static get(String url) async{
    return  dio.get(url);
  }
  static postForm(String url,var data) async{
    Response response;
    try {
      response = await dio.post(url,data:new FormData.from(data));
      return response.data;
    }on DioError catch (e) {
        return {
          "result":-1,
          "message":"网络异常"
        };
      }
  }

  static postFormUrl(String url) async{
    Response response;
    try {
      response = await dio.post(url);
      return response.data;
    }on DioError catch (e) {
      return {
        "result":-1,
        "message":"网络异常"
      };
    }
  }

  static urlForm(String url,var params) async{
    Response response;
    try {
      if (params != null && params.isNotEmpty) {
        // 如果参数不为空，则将参数拼接到URL后面
        StringBuffer sb = new StringBuffer("?");
        params.forEach((key, value) {
          sb.write("$key" + "=" + "$value" + "&");
        });
        String paramStr = sb.toString();
        paramStr = paramStr.substring(0, paramStr.length - 1);
        url += paramStr;
      }
      response = await dio.post(url);
      return response.data;
    }on DioError catch (e) {
      return {
        "result":-1,
        "message":"网络异常"
      };
    }
  }
}