import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AvailableConnection {
  ///fungsi ini hanya untuk mengecek internet ada atau tidak, tidak bisa listen jika connectivity ditukar
  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool result = false;

    if (connectivityResult == ConnectivityResult.mobile) {
      // if (await InternetConnectionChecker().hasConnection) {
      //   return Future<bool>.value(true);
      // } else {
      //   return Future<bool>.value(false);
      // }
      InternetConnectionChecker().onStatusChange.listen((status) {
        if (status == InternetConnectionStatus.connected) {
          result = true;
        } else if (status == InternetConnectionStatus.disconnected) {
          result = false;
        }
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // if (await InternetConnectionChecker().hasConnection) {
      //   return Future<bool>.value(true);
      // } else {
      //   return Future<bool>.value(false);
      // }
      InternetConnectionChecker().onStatusChange.listen((status) {
        if (status == InternetConnectionStatus.connected) {
          result = true;
        }else if (status == InternetConnectionStatus.disconnected) {
          result = false;
        }
       });
    } else {
      // return Future<bool>.value(false);
      result = false;
    }
    return Future<bool>.value(result);
  }
}
