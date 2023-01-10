import 'dart:convert';

import 'package:Mychildcare/api_collection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Mychildcare/admin/teacher/menu_food_add_screen.dart';
import 'package:Mychildcare/users/model/menu_food.dart';

class MenuFoodScreen extends StatefulWidget {
  const MenuFoodScreen({super.key});

  @override
  State<MenuFoodScreen> createState() => _MenuFoodScreenState();
}

class _MenuFoodScreenState extends State<MenuFoodScreen> {
  Future<List<MenuFood>> getAllFoodMenu() async {
    List<MenuFood> allFoodMenuItemList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllMenu));

      if (res.statusCode == 200) {
        var responseOfAllChildren = jsonDecode(res.body);
        if (responseOfAllChildren["success"] == true) {
          print('Asaxszx success');
          (responseOfAllChildren["menuData"] as List).forEach((eachRecord) {
            allFoodMenuItemList.add(MenuFood.fromJson(eachRecord));
          });
        } else {
          print('asdzsczsdasdasdzd fail');
        }
      } else {
        print('Error, status code is not 200');
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }
    print('aasssdfdsfdsdcdcccc');
    print(allFoodMenuItemList);
    return allFoodMenuItemList;
  }

  deleteFoodMenuItem(int menu_id) async {
    try {
      var res = await http.post(Uri.parse(API.deleteMenu), body: {
        "menu_id": menu_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if (responseBodyFromDeleteCart["success"] == true) {
          setState(() {
            getAllFoodMenu();
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    } catch (errorMessage) {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

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
      body: allItemWidget(context),
    );
  }

  allItemWidget(context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: getAllFoodMenu(),
          builder: (context, AsyncSnapshot<List<MenuFood>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapShot.data == null) {
              return const Center(
                child: Text(
                  "No Trending item found",
                ),
              );
            }
            if (dataSnapShot.data!.length > 0) {
              return ListView.builder(
                itemCount: dataSnapShot.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  // List list = dataSnapShot.data!;
                  MenuFood eachFoodMenuItemRecord = dataSnapShot.data![index];

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        16,
                        index == 0 ? 16 : 8,
                        16,
                        index == dataSnapShot.data!.length - 1 ? 16 : 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.lightBlue,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 6,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          //name + price
                          //tags
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name and price
                                  Row(
                                    children: [
                                      //name
                                      Expanded(
                                        child: Text(
                                          eachFoodMenuItemRecord.menu_name!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () {
                                            //soon
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteFoodMenuItem(
                                              eachFoodMenuItemRecord.menu_id!);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Empty, No Data."),
              );
            }
          }),
    );
  }
}
