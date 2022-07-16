import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';


enum ExtPublicDir {
  Music,
  PodCasts,
  Ringtones,
  Alarms,
  Notifications,
  Pictures,
  Movies,
  Download,
  DCIM,
  Documents,
  Screenshots,
  Audiobooks,
}

// https://stackoverflow.com/questions/54379206/flutter-create-directory-on-external-storage-path-path-provider-getexternals
class ExtStorage {

  //According to path_provider
  static Future<String> get _directoryPathESD async {
    var directory = await getExternalStorageDirectory();
    if (directory != null) {
      log('directory:${directory.path}');

      return directory.path;
    }
    log('_directoryPathESD==null');

    return '';
  }

  static Future<String> createFolderInPublicDir({
    required ExtPublicDir type,
    required String folderName,
  }) async {

    var _appDocDir = await _directoryPathESD;

    log("createFolderInPublicDir:_appDocDir:${_appDocDir.toString()}");

    var values = _appDocDir.split(Platform.pathSeparator);
    values.forEach(print);

    var dim = values.length - 4; // Android/Data/package.name/files
    _appDocDir = "";

    for (var i = 0; i < dim; i++) {
      _appDocDir += values[i];
      _appDocDir += Platform.pathSeparator;
    }
    _appDocDir += "${type.toString().split('.').last}${Platform.pathSeparator}";
    _appDocDir += folderName;

    log("createFolderInPublicDir:_appDocDir:$_appDocDir");

    if (await Directory(_appDocDir).exists()) {
      log("createFolderInPublicDir:reTaken:$_appDocDir");

      return _appDocDir;
    } else {
      log("createFolderInPublicDir:toCreate:$_appDocDir");
      //if folder not exists create folder and then return its path
      final _appDocDirNewFolder =
      await Directory(_appDocDir).create(recursive: true);
      final pathNorma = Path.normalize(_appDocDirNewFolder.path);
      log("createFolderInPublicDir:ToCreate:pathNorma:$pathNorma");

      return pathNorma;
    }
  }
}