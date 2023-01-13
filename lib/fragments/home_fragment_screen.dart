import 'dart:convert';

import 'package:Mychildcare/users/model/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../users/userPreferences/current_user.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';

class HomeFragmentScreen extends StatelessWidget {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  Future<List<Activity>> getAllActivity() async {
    List<Activity> allActivityItemList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllActivity));

      if (res.statusCode == 200) {
        var responseOfAllActivity = jsonDecode(res.body);
        if (responseOfAllActivity["success"] == true) {
          print('Asaxszx success');
          (responseOfAllActivity["activityData"] as List).forEach((eachRecord) {
            allActivityItemList.add(Activity.fromJson(eachRecord));
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
    print(allActivityItemList);
    return allActivityItemList;
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
          body: allItemWidget(context),
        );
      },
    );
  }

  allItemWidget(context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: getAllActivity(),
          builder: (context, AsyncSnapshot<List<Activity>> dataSnapShot) {
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
                  Activity eachActivityItemRecord = dataSnapShot.data![index];

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
                        color: Colors.lightBlue.shade300,
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
                                  Column(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.fill,
                                        child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.zero,
                                          // borderRadius: const BorderRadius.only(
                                          //   topRight: Radius.circular(20),
                                          //   bottomRight: Radius.circular(20),
                                          // ),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            alignment: Alignment.center,
                                            child: FadeInImage(
                                              // alignment: Alignment.center,
                                              height: 250,
                                              width: 300,
                                              placeholder: const AssetImage(
                                                  "images/place_holder_1.png"),
                                              image: NetworkImage(
                                                eachActivityItemRecord
                                                    .activity_image!,
                                              ),
                                              imageErrorBuilder: (context,
                                                  error, stackTraceError) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.broken_image_outlined,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //name and price
                                  Row(
                                    children: [
                                      //name
                                      Expanded(
                                        child: Text(
                                          eachActivityItemRecord
                                              .activity_description!,
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
                                  Column(
                                    children: [
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                eachActivityItemRecord
                                                    .activity_date!)),
                                        // eachActivityItemRecord.activity_date!,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        eachActivityItemRecord.activity_start!,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        eachActivityItemRecord.activity_end!,
                                      )
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
