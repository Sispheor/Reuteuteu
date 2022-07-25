import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:sloth_day/pages/list_bucket.dart';
import 'package:sloth_day/utils/shared_preferences%20_manager.dart';

enum DatabaseLocation {unknown, restricted, shared}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SlothDay());
}

class SlothDay extends StatefulWidget {


  const SlothDay({Key? key}) : super(key: key);

  @override
  State<SlothDay> createState() => _SlothDayState();
}

class _SlothDayState extends State<SlothDay> {

  Future<DatabaseLocation> _asyncGetDatabaseLocation() async {
    return await SharedPrefManager.getDatabaseLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Sloth',
      themeMode: ThemeMode.dark, // Or [ThemeMode.dark]
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      // home: const ListBucketPage(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: NordColors.polarNight.darkest,
          title: const Text('Select database location'),
        ),
        body: FutureBuilder<DatabaseLocation>(
          future: _asyncGetDatabaseLocation(),
          initialData: DatabaseLocation.unknown,
          builder: (BuildContext context, AsyncSnapshot<DatabaseLocation> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (!snapshot.hasData) {
              // while data is loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data == DatabaseLocation.unknown){
                return  Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.phonelink_lock),
                          title: Text('Database in a private folder'),
                          subtitle: Text('Database files are placed into a private folder. Files are not visible from an external app like a file browser. '
                              'Data are destroyed when the app is deleted. \n\n\nNote: No extra permission required.'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              child: const Text('Select'),
                              onPressed: () {
                                // set in pref the selected location
                                SharedPrefManager.setDatabaseLocation(DatabaseLocation.restricted);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListBucketPage(databaseLocation: DatabaseLocation.restricted)),
                                      (Route<dynamic> route) => false,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        Container(
                            height: 10,
                            color: NordColors.polarNight.darkest
                        ),
                        const ListTile(
                          leading: Icon(Icons.smartphone),
                          title: Text('Database in a shared folder'),
                          subtitle: Text('The database files are placed into a folder placed into the \'Documents\' folder of your phone. Files are visible from third party application. Data are still present after deleting the app.'
                              ' Select this mode if you want to synchronize the database with a cloud app like NextCloud, Google Drive or OneDrive. \n\nNote: Permission to access the shared storage will be asked.'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              child: const Text('Select'),
                              onPressed: () {
                                SharedPrefManager.setDatabaseLocation(DatabaseLocation.shared);
                                Navigator.pushReplacement (
                                    context,
                                    MaterialPageRoute(builder: (context) => const ListBucketPage(databaseLocation: DatabaseLocation.shared))
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        )
                      ],
                    ),
                  ),
                );

              }
              if (snapshot.data == DatabaseLocation.restricted){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ListBucketPage(databaseLocation: DatabaseLocation.restricted))
                  );
                });
              }
              if (snapshot.data == DatabaseLocation.shared){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ListBucketPage(databaseLocation: DatabaseLocation.shared))
                  );
                });
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
