import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class Connection {
  static final Dio _dio = Dio();
  static final Box _utilsBox = Hive.box('utils');
  static bool _justLogin = false;

  Connection() {
    _dio.options.baseUrl = 'https://monefyte-server.herokuapp.com/';
    _dio.options.headers['Authorization'] = "Bearer ${getToken()}";
  }

  static Dio makeConnection() {
    return _dio;
  }

  static Future<void> insertLoginInfo(
      {required String token, required String name}) async {
    _dio.options.headers['Authorization'] = "Bearer $token";
    await _utilsBox.put('token', token);
    await _utilsBox.put('userName', name);
    _justLogin = true;
  }

  static String? getToken() {
    return _utilsBox.get('token');
  }

  static String? getUserName() {
    return _utilsBox.get('userName');
  }

  static Future<void> removeLoginInfo() async {
    await _utilsBox.delete('token');
    await _utilsBox.delete('userName');
    _justLogin = false;
  }

  static bool isLoggedin() {
    if (getToken() == null || getUserName() == null) {
      return false;
    }
    return true;
  }

  static bool isJustLogin() {
    return _justLogin;
  }
}
