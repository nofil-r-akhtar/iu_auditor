import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<bool> checkNativeConnectivity() async {
  return await InternetConnection().hasInternetAccess;
}