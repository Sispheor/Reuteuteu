import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sloth_day/adapters.dart';
import 'package:sloth_day/const.dart';
import 'package:sloth_day/dev_utils/testing_data.dart';
import 'package:sloth_day/hive_boxes.dart';
import 'package:sloth_day/main.dart';
import 'package:sloth_day/models/day_off.dart';
import 'package:sloth_day/models/pool.dart';
import 'package:sloth_day/pages/create_or_edit_bucket.dart';
import 'package:sloth_day/utils/android_file_interface.dart';
import 'package:sloth_day/utils/external_storage.dart';
import 'package:sloth_day/utils/shared_preferences%20_manager.dart';
import 'package:sloth_day/widgets/bucket_card.dart';

import '../models/bucket.dart';

class ListBucketPage extends StatefulWidget {

  final DatabaseLocation databaseLocation;

  const ListBucketPage({Key? key, required this.databaseLocation}) : super(key: key);

  @override
  _ListBucketPageState createState() => _ListBucketPageState();
}

class _ListBucketPageState extends State<ListBucketPage> {

  Future<bool>? _databaseLoadedOnce;

  @override
  void initState() {
    super.initState();

    // initial load
    _databaseLoadedOnce = isDataBaseLoaded();
  }

  Future<File> _localFile(String documentPath) async {
    // final path = await documentPath;
    return File('$documentPath/buckets.hive');
  }

  Future<bool> isDataBaseLoaded() async {
    if (_databaseLoadedOnce != null && _databaseLoadedOnce == true){
      return true;
    }
    log("Async load database");
    if (widget.databaseLocation == DatabaseLocation.restricted){
      await Hive.initFlutter();
    }else{
      // try to get the storage perm
      if (await Permission.storage.request().isGranted) {
        String createdPath = await ExtStorage.createFolderInPublicDir(
          type: ExtPublicDir.Documents,
          folderName: dbFolderName,
        );
        // check if we have read rights
        bool bucketDb = await File('$createdPath/buckets.hive').exists();
        if (bucketDb){
          log("buckets.hive exist already. Trying read access");
          // get the file
          File existingDB = File('$createdPath/buckets.hive');
          // Read the file
          try{
            Uint8List contents = await existingDB.readAsBytes();
            log("Read access ok");
          }catch (e) {
            log("Read access refused ${e}");
            // poc file picker
            // String? selectedDirectory = await FilePicker.platform.getDirectoryPath(initialDirectory: createdPath);
            // if (selectedDirectory == null) {
            //   // User canceled the picker
            //   return false;
            // }

            // poc file picker writable
            final AndroidInterface _androidInterface = AndroidInterface();
            final contentRoot = await _androidInterface.selectDirectory();

          }

        }

        // init the database with the Document folder
        await Hive.initFlutter(createdPath);
      }else{ // storage perm refused by the user, go back to selection
        await SharedPrefManager.setDatabaseLocation(DatabaseLocation.unknown);
        // go back to selection screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SlothDay())
        );
        return false;
      }
    }
    if (!Hive.isAdapterRegistered(200)) {
      Hive.registerAdapter(ColorAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DayOffAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PoolAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(BucketAdapter());
    }

    var bucketBox = await Hive.openBox<Bucket>('buckets');
    var poolBox = await Hive.openBox<Pool>('pools');
    var dayOffBox = await Hive.openBox<DayOff>('day_offs');

    // if (kDebugMode){
    //   log("App started with debug mode. Creating testing data");
    //   createTestingData(bucketBox, poolBox, dayOffBox);
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: NordColors.polarNight.darkest,
            title: const Text("SlothDay"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CreateOrEditBucketPage(isEdit: false)));
                },
              )
            ],
          ),
          body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/sloth5.png"),
                    fit: BoxFit.fitWidth),
              ),
              child: FutureBuilder<bool>(
                  future: _databaseLoadedOnce,
                  initialData: false,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data == false) {
                      // while data is loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data == true){
                        return ValueListenableBuilder<Box<Bucket>>(
                          valueListenable: Boxes.getBuckets().listenable(),
                          builder: (context, box, _) {
                            final buckets = box.values.toList().cast<Bucket>();
                            if (buckets.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No buckets yet',
                                  style: TextStyle(fontSize: 24),
                                ),
                              );
                            }else{
                              return ListView(
                                children: buckets.map((bucket) => BucketCardWidget(bucket: bucket)).toList(),
                              );
                            }
                          },
                        );
                      }
                    }
                    return const Text('Loading database');
                  }
              )

          )

      ),
    );
  }
}


