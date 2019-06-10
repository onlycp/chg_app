import 'package:chp_app/api/apis.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio _dio;

  static DioFactory _instance;

  static DioFactory getInstance() {
    if (_instance == null) {
      _instance = new DioFactory._();
      _instance._init();
    }
    return _instance;
  }

  DioFactory._();

  _init() {
    _dio = new Dio();
    _dio.options.baseUrl = Apis.HOST;
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;

    Dio tokenDio = new Dio();
    tokenDio.options = _dio.options;
    _dio.interceptor.request.onSend = (Options options) {
      if (Constants.token != null) {
        options.headers["Authorization"] = Constants.token;
      }
      return options;
    };

    _dio.interceptor.response.onError = (DioError error) {
      // Assume 401 stands for token expired
      if(error.response?.statusCode==401){
        Options options=error.response.request;
        // If the token has been updated, repeat directly.
        if(Constants.token!=options.headers["Authorization"]){
          options.headers["Authorization"]=Constants.token;
          //repeat
          return  _dio.request(options.path,options: options);
        }
        // update token and repeat
        // Lock to block the incoming request until the token updated
        _dio.interceptor.request.lock();
        _dio.interceptor.response.lock();
        return tokenDio.post(Apis.refreshToken).then((d) {
          //update csrfToken
          options.headers["Authorization"] = Constants.token = d.data['data']['token'];
        }).whenComplete((){
          _dio.interceptor.request.unlock();
          _dio.interceptor.response.unlock();
        }).then((e){
          //repeat
          return _dio.request(options.path,options: options);
        });
      }
      return error;
    };

  }

  getDio() {
    return _dio;
  }
}

//测试是否是单例
void main() {
  print(DioFactory.getInstance().getDio() == DioFactory.getInstance().getDio());
}
