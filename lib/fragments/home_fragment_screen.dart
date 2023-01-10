import 'dart:convert';

import 'package:Mychildcare/users/model/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../users/userPreferences/current_user.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';

class HomeFragmentScreen extends StatelessWidget {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  Future<List<Activity>> getAllFoodMenu() async {
    List<Activity> allFoodMenuItemList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllActivity));

      if (res.statusCode == 200) {
        var responseOfAllChildren = jsonDecode(res.body);
        if (responseOfAllChildren["success"] == true) {
          print('Asaxszx success');
          (responseOfAllChildren["activityData"] as List).forEach((eachRecord) {
            allFoodMenuItemList.add(Activity.fromJson(eachRecord));
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          body: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      5,
                      6,
                      1,
                      6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
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
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        child: FadeInImage(
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                          placeholder: const AssetImage(
                                              "images/place_holder_1.png"),
                                          image: NetworkImage(
                                            'images/place_holder_1.png',
                                          ),
                                          imageErrorBuilder: (context, error,
                                              stackTraceError) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    //name
                                    Expanded(
                                      child: Text(
                                        'Description',
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
                                  children: [Text('activity date')],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text('Activity time start'),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text('Activity time end'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //image clothes
                      ],
                    ),
                  ),
                ),
              ]),
        );
      },
    );
  }
}
