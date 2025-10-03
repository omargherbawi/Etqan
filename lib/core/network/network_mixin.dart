import 'package:connectivity_plus/connectivity_plus.dart';

mixin NetworkMixin {
  final Connectivity _connectivity = Connectivity();

  /// Check if the device is currently connected to the internet.
  Future<bool> get isConnected async {
    List<ConnectivityResult> connectivityResults =
        await _connectivity.checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
  }

  /// Stream to listen for connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
