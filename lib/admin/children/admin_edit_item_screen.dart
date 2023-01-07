import 'dart:convert';

import 'package:Mychildcare/users/model/children.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../users/model/classroom.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';

class AdminEditItemScreen extends StatelessWidget {
  Future<List<Children>> getAllChildrenItem() async {
    List<Children> allChildrenItemList = [];

    try {
      var res = await http.post(Uri.parse(API.updateChildren));

      if (res.statusCode == 200) {
        var responseBodyOfAllChildren = jsonDecode(res.body);
        if (responseBodyOfAllChildren["success"] == true) {
          print('Asaxszx success');
          (responseBodyOfAllChildren["childrenData"] as List)
              .forEach((eachRecord) {
            allChildrenItemList.add(Children.fromJson(eachRecord));
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
    print(allChildrenItemList);
    return allChildrenItemList;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
