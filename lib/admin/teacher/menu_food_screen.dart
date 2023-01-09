import 'package:Mychildcare/admin/teacher/menu_food_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';

class MenuFoodScreen extends StatefulWidget {
  const MenuFoodScreen({super.key});

  @override
  State<MenuFoodScreen> createState() => _MenuFoodScreenState();
}

class _MenuFoodScreenState extends State<MenuFoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Menu List'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Get.to(MenuFoodAddScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
