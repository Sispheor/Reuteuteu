import 'dart:typed_data';

import 'package:flutter/services.dart';

class FileOperationResult {
  Object? result;
  String? message;
  FileOperationError? error;

  FileOperationResult({this.result, this.message, this.error});
}

enum FileOperationError {
  success,
  noSavedPersistRoot,
  pending,
  accessError,
  alreadyExists,
  creationFailed,
  canceled,
  unknown
}

class AndroidInterface {
  // Channel methods:
  // root getPersistRoot()
  // root selectDirectory()
  // void releaseDirectory(root)
  // root createDirectory(root, name, overwrite)
  // void writeFile(root, subdir, name, type, overwrite, bytes)

  final _platform = MethodChannel('package/Main');
  final _errors = {
    'no persist document tree': FileOperationError.noSavedPersistRoot,
    'pending': FileOperationError.pending,
    'access error': FileOperationError.accessError,
    'exists': FileOperationError.alreadyExists,
    'creation failed': FileOperationError.creationFailed,
    'canceled': FileOperationError.canceled,
  };

  String? _root;

  // invoke a method with given arguments
  Future<FileOperationResult> _invoke(
      String method, {
        bool returnVoid = false,
        String? root,
        String? subdir,
        String? name,
        Uint8List? bytes,
        bool? overwrite,
      }) async {
    try {
      final result = await _platform.invokeMethod<String>(method, {
        'root': root,
        'subdir': subdir,
        'name': name,
        'bytes': bytes,
        'overwrite': overwrite,
      });
      if (result != null || returnVoid) {
        return FileOperationResult(result: result);
      }

      return FileOperationResult(error: FileOperationError.unknown);
    } on PlatformException catch (e) {
      final error = _errors[e.code] ?? FileOperationError.unknown;

      return FileOperationResult(
        error: error,
        result: e.code,
        message: e.message,
      );
    }
  }

  // @override
  // Future<FileOperationResult> getPersistRoot() async {
  //   final result = await _invoke('getSavedRoot');
  //   if (result.error == FileOperationError.success) _root = result.result;
  //   return result;
  // }

  @override
  Future<FileOperationResult> selectDirectory() async {
    final result = await _invoke('selectDirectory');
    // release currently selected directory if new directory selected successfully
    if (result.error == FileOperationError.success) {
      if (_root != null) {
        await _invoke('releaseDirectory', root: _root, returnVoid: true);
      }
      _root = result.result as String;
    }
    return result;
  }

  // @override
  // Future<FileOperationResult<String>> createDirectory(
  //     String root,
  //     String name, [
  //       bool? overwrite,
  //     ]) async {
  //   final result = await _invoke(
  //     'createDirectory',
  //     root: root,
  //     name: name,
  //     overwrite: overwrite,
  //   );
  //   return result;
  // }
  //
  // @override
  // Future<FileOperationResult> writeFile(
  //     String root,
  //     String subdir,
  //     String name,
  //     Uint8List bytes, [
  //       bool? overwrite,
  //     ]) async {
  //   final result = await _invoke(
  //     'writeFile',
  //     root: root,
  //     subdir: subdir,
  //     name: name,
  //     bytes: bytes,
  //     overwrite: overwrite,
  //     returnVoid: true,
  //   );
  //   return result;
  // }
}