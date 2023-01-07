import 'package:Mychildcare/admin/classroom/classroom_screen.dart';
import 'package:Mychildcare/admin/teacher/menu_food_screen.dart';
import 'package:Mychildcare/admin/teacher/teacher_acitivity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mychildcare/admin/children/admin_upload_items_screen.dart';
import 'package:Mychildcare/admin/children/admin_children_screen.dart';

class TeacherClassroomSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Main Menu')),
      body: GridView.count(
        padding: const EdgeInsets.all(25),
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {},
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
                Get.to(TeacherActivityScreen());
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
                    Text("Activity", style: TextStyle(fontSize: 17.0)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Get.to(MenuFoodScreen());
              },
              splashColor: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.rice_bowl,
                      size: 70,
                      color: Colors.greenAccent,
                    ),
                    Text("Food Menu", style: TextStyle(fontSize: 17.0)),
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
