import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Mychildcare/admin/classroom/classroom_save_screen.dart';
import 'package:Mychildcare/users/model/classroom.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';
import 'package:Mychildcare/users/model/children.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  Future<List<Classroom>> getAllClassroomItem() async {
    List<Classroom> allClassroomItemList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllClassroom));

      if (res.statusCode == 200) {
        var responseBodyOfAllClassroom = jsonDecode(res.body);
        if (responseBodyOfAllClassroom["success"] == true) {
          print('Asaxszx success');
          (responseBodyOfAllClassroom["classroomData"] as List)
              .forEach((eachRecord) {
            allClassroomItemList.add(Classroom.fromJson(eachRecord));
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
    print(allClassroomItemList);
    return allClassroomItemList;
  }

  @override
  Widget build(BuildContext context) {
    return defaultScreen(context);
  }

  Widget defaultScreen(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Children'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Get.to(ClassRoomSaveScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: allItemWidget(context),
    );
  }

  allItemWidget(context) {
    return FutureBuilder(
        future: getAllClassroomItem(),
        builder: (context, AsyncSnapshot<List<Classroom>> dataSnapShot) {
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
                Classroom eachItemClassRoomRecord = dataSnapShot.data![index];

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
                                        'Classroom: ' +
                                            eachItemClassRoomRecord
                                                .classroom_name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
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
                                          //nanti buat
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        //nanti buat
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
        });
  }
}
