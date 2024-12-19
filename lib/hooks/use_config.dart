import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:motolisto/hooks/use_url.dart';
import 'package:package_info_plus/package_info_plus.dart';

_versionStringToNumber(String version) {
  List<String> versionArray = version.split('.');
  int major = int.parse(versionArray[0]);
  int minor = int.parse(versionArray[1]);
  int patch = int.parse(versionArray[2]);
  return major * 10000 + minor * 100 + patch;
}

validateMinimumVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String localVersion = packageInfo.version;
  String remoteMinimumVersion =
      await FirebaseRemoteConfig.instance.getString('minimum_version');
  debugPrint(
      '🎸🎸🎸 Remote version: $remoteMinimumVersion and local version: $localVersion');
  if (_versionStringToNumber(localVersion) <
      _versionStringToNumber(remoteMinimumVersion)) {
    debugPrint('🎸🎸🎸 Closing app and open STORE');
    openStore();
  } else
    debugPrint('🎸🎸🎸 Local version ACEPTED: $localVersion');
}
