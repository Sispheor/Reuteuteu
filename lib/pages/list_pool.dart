

import 'package:flutter/material.dart';
import 'package:reuteuteu/models/bucket.dart';


class ListPoolPage extends StatefulWidget {

  final Bucket bucket;

  const ListPoolPage({Key? key,
    required this.bucket}) : super(key: key);

  @override
  _ListPoolPageState createState() => _ListPoolPageState();
}

class _ListPoolPageState extends State<ListPoolPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket ${widget.bucket.name}"),
      ),
      body: Column(
        children: [
          Card(
            child: Column(
                children: [
                  ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(widget.bucket.getPoolMaxDays().toString(),
                                style: const TextStyle(color: Colors.white))
                        ),
                      ),
                      title: const Text('Total', style: TextStyle(color: Colors.black))
                  ),
                  ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(widget.bucket.getTakenDays().toString(),
                                style: const TextStyle(color: Colors.white))
                        ),
                      ),
                      title: const Text('Consumed', style: TextStyle(color: Colors.black))
                  ),
                  ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(widget.bucket.getAvailable().toString(),
                                style: const TextStyle(color: Colors.white))
                        ),
                      ),
                      title: const Text('Available', style: TextStyle(color: Colors.black))
                  ),
                ]
            ),
          )
        ],
      ),

    );
  }
}