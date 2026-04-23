import 'package:flutter/foundation.dart';

// Conditional import — dart:io only compiles on non-web platforms.
// Without this, internet_connection_checker_plus (which uses dart:io)
// crashes on Flutter web at startup with main.dart.js:6001.
import 'connectivity_stub.dart'
    if (dart.library.io) 'connectivity_native.dart';

class CheckConnectivity {
  Future<bool> isConnected() async {
    if (kIsWeb) return true; // browser handles its own connectivity
    return await checkNativeConnectivity();
  }
}