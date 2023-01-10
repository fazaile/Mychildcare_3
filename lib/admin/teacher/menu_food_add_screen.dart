import 'dart:convert';

import 'package:Mychildcare/admin/teacher/menu_food_screen.dart';
import 'package:Mychildcare/users/model/menu_food.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Mychildcare/api_collection/api_connection.dart';

class MenuFoodAddScreen extends StatefulWidget {
  const MenuFoodAddScreen({super.key});

  @override
  State<MenuFoodAddScreen> createState() => _MenuFoodAddScreenState();
}

class _MenuFoodAddScreenState extends State<MenuFoodAddScreen> {
  var nameController = TextEditingController();
  var dateController = TextEditingController();
  var startController = TextEditingController();
  var endController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  saveItemInfoToDatabase() async {
    try {
      var response = await http.post(Uri.parse(API.uploadNewMenu), body: {
        'menu_id': '1',
        //drop down box sini
        'menu_name': nameController.text,
        'menu_date': dateController.text,
        'menu_start_time': startController.text,
        'menu_end_time': endController.text,
      });
      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success'] = true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");
          setState(() {
            nameController.clear();
            dateController.clear();
            startController.clear();
            endController.clear();
            MenuFoodScreen();
            Get.to(MenuFoodScreen());
          });
        } else {
          Fluttertoast.showToast(msg: 'Item not uploaded.Error,Try again');
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print('Errorr::' + errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: [
                    //item name
                    TextFormField(
                      controller: nameController,
                      validator: (val) =>
                          val == "" ? "Please enter Food name" : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.title,
                          color: Colors.black,
                        ),
                        hintText: "enter Food name...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextFormField(
                      controller: dateController,
                      validator: (val) =>
                          val == "" ? "Please enter date" : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.date_range,
                          color: Colors.black,
                        ),
                        hintText: "Enter Date...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onTap: () async {
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));

                        dateController.text = date!.toIso8601String();
                      },
                    ),

                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      controller: startController,
                      validator: (val) =>
                          val == "" ? "Please enter start time" : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_clock_rounded,
                          color: Colors.black,
                        ),
                        hintText: "Enter start time...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onTap: () async {
                        TimeOfDay? timeOfDay = TimeOfDay(hour: 8, minute: 30);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        startController.text = timeOfDay!.toString();
                      },
                    ),

                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      controller: endController,
                      validator: (val) =>
                          val == "" ? "Please enter end time" : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_clock_rounded,
                          color: Colors.black,
                        ),
                        hintText: "Enter end time...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onTap: () async {
                        TimeOfDay? timeOfDay = TimeOfDay(hour: 8, minute: 30);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        endController.text = timeOfDay!.toString();
                      },
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    ElevatedButton(
                      child: Text("Add Menu"),
                      onPressed: () {
                        saveItemInfoToDatabase();
                        setState(() {
                          nameController.clear();
                          dateController.clear();
                          startController.clear();
                          endController.clear();
                          MenuFoodScreen();
                          Get.to(MenuFoodScreen());
                        });
                      },
                    ),

                    //button
                    // Material(
                    //   color: Colors.black,
                    //   borderRadius: BorderRadius.circular(30),
                    //   child: InkWell(
                    //     onTap: () {
                    //       if (formKey.currentState!.validate()) {
                    //         Fluttertoast.showToast(msg: 'Uploading now..');
                    //         uploadItemImage();
                    //       }
                    //       setState(() {
                    //         defaultScreen();
                    //       });
                    //     },
                    //     borderRadius: BorderRadius.circular(30),
                    //     child: const Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: 10,
                    //         horizontal: 28,
                    //       ),
                    //       child: Text(
                    //         "Upload Now",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // ElevatedButton(
              //   child: Text("Add Menu"),
              //   onPressed: () {
              //     saveItemInfoToDatabase();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
