import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CheckConnectivity {
  // Method to check internet connectivity
  Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }
}