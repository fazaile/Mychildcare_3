import 'package:Mychildcare/admin/classroom/classroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mychildcare/admin/children/admin_upload_items_screen.dart';
import 'package:Mychildcare/admin/children/admin_children_screen.dart';
import 'children/admin_upload_items_screen.dart';

class AdminMainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Main Menu')),
      body: GridView.count(
        padding: const EdgeInsets.all(25),
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Get.to(AdminChildrenScreen());
              },
              splashColor: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.child_care,
                      size: 70,
                      color: Colors.blueAccent,
                    ),
                    Text("Children", style: TextStyle(fontSize: 17.0)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                AdminUploadItemScreen();
              },
              splashColor: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.book,
                      size: 70,
                      color: Colors.redAccent,
                    ),
                    Text("Teacher", style: TextStyle(fontSize: 17.0)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Get.to(ClassroomScreen());
              },
              splashColor: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.house,
                      size: 70,
                      color: Colors.greenAccent,
                    ),
                    Text("Classroom", style: TextStyle(fontSize: 17.0)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
