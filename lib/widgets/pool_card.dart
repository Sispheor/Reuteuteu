import 'package:flutter/material.dart';
import 'package:reuteuteu/models/pool.dart';
import 'package:reuteuteu/pages/list_day_off.dart';

class PoolCardWidget extends StatelessWidget {

  const PoolCardWidget({
    Key? key,
    required this.pool
  }) : super(key: key);

  final Pool pool;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(pool.name),
              onTap: () {
                if(pool.dayOffList!.isNotEmpty){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ListDayOffPage(pool: pool);
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

