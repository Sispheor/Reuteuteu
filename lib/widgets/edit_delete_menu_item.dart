import 'package:flutter/material.dart';

enum Options { edit, delete }

List<PopupMenuEntry> popupMenuItemEditDelete (){
  return <PopupMenuEntry>[
    PopupMenuItem(
      value: Options.edit,
      child:  Row(
        children: const [
          Icon(Icons.edit),
          Text("Edit"),
        ],
      ),
    ),
    PopupMenuItem(
      value: Options.delete,
      child:  Row(
        children: const [
          Icon(Icons.delete, color: Colors.red),
          Text("Delete", style: TextStyle(color: Colors.red)),
        ],
      ),
    )
  ];
}
