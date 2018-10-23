import 'package:dio/dio.dart';
import 'package:chyy_app/common/config/server.dart';

class HttpUtils{
  static Options _options= new Options(
      baseUrl:ServerConfig.mesUrl,
      connectTimeout:5000,
      receiveTimeout:3000
  );

  static Dio dio = new Dio(_options);

  static postForm(String url,var data) async{
    Response response;
    try {
      response = await dio.post(url,data:new FormData.from(data));
   //   print("resp $response");
      return response.data;
    }on DioError catch (e) {
      print(e);
      return {
        "result":-1,
        "message":"网络错误: ${e.message}"
      };
    }
  }
}