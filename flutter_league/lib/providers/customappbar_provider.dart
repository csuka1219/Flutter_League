import 'package:flutter/material.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class CustomAppBarProvider with ChangeNotifier {
  String? _serverName;
  String? get serverName => _serverName;

  set serverName(String? text) {
    _serverName = text;
    notifyListeners();
  }

  Future<void> init() async {
    String? serverId = await getServerId();
    serverName = serverId == null ? "EUNE" : getServerName(serverId);
  }
}
