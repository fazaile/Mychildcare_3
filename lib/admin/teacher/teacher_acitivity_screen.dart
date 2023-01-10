import 'dart:convert';
import 'dart:io';

import 'package:Mychildcare/users/model/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import 'package:Mychildcare/admin/admin_login_screen.dart';
import 'package:Mychildcare/admin/children/admin_edit_item_screen.dart';
import 'package:Mychildcare/admin/admin_main_menu_screen.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';
import 'package:Mychildcare/users/model/children.dart';
import 'package:Mychildcare/users/model/classroom.dart';

class TeacherActivityScreen extends StatefulWidget {
  const TeacherActivityScreen({super.key});

  @override
  State<TeacherActivityScreen> createState() => _TeacherActivityScreenState();
}

class _TeacherActivityScreenState extends State<TeacherActivityScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImagedFileX;

  var formKey = GlobalKey<FormState>();
  var descriptionController = TextEditingController();
  var dateController = TextEditingController();
  var startController = TextEditingController();
  var endController = TextEditingController();
  // var tagsController = TextEditingController();
  // var sizesController = TextEditingController();
  // var colorsController = TextEditingController();
  // var descriptionController = TextEditingController();
  var imageLink = '';

  //defaultScreen methods
  captureImageWithPhoneCamera() async {
    pickedImagedFileX = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() {
      pickedImagedFileX;
    });
  }

  pickImageFromPhoneGallery() async {
    pickedImagedFileX = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() {
      pickedImagedFileX;
    });
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              'Item image',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  'Capture with phone camera',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  'Select Image From Phone Gallery',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }
  //default screen methods ends here

//uploadItemFormScreen methods
  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "55eaa7530afc3ed";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImagedFileX!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();

    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    print('imageLink ::');
    print(imageLink);

    print('deleteHash ::');
    print(deleteHash);

    saveItemInfoToDatabase();
  }

  saveItemInfoToDatabase() async {
    try {
      print('akaskjsajkljasljaj sini');
      print(imageLink);
      var response = await http.post(Uri.parse(API.uploadNewActivity), body: {
        'activity_id': '1',
        //drop down box sini
        'activity_description': descriptionController.text,
        'activity_date': dateController.text,
        'activity_start': startController.text,
        'activity_end': endController.text,
        'activity_image': imageLink.toString(),
      });
      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success'] = true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImagedFileX = null;
            descriptionController.clear();
            dateController.clear();
            startController.clear();
            endController.clear();
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

  deleteActivity(int activity_id) async {
    try {
      var res = await http.post(Uri.parse(API.deleteActivity), body: {
        "activity_id": activity_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if (responseBodyFromDeleteCart["success"] == true) {
          setState(() {
            getAllActivity();
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

  //uploadItemFormScreen methods ends here

  Widget uploadItemFromScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue,
                Colors.lightBlue,
              ],
            ),
          ),
        ),
        title: const Text('Upload Children Form'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImagedFileX = null;
              descriptionController.clear();
              dateController.clear();
              startController.clear();
              endController.clear();
            });

            Get.to(TeacherActivityScreen());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Fluttertoast.showToast(msg: "Uploading now...");

                defaultScreen();
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
        ],
        automaticallyImplyLeading: false,
      ),
      body: ListView(children: [
        //image
        Container(
          height: 240,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(
                File(pickedImagedFileX!.path),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //upload item form
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(
                Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black26,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
              child: Column(
                children: [
                  //email-password-login button
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //item name
                        TextFormField(
                          controller: descriptionController,
                          validator: (val) =>
                              val == "" ? "Please enter description" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.black,
                            ),
                            hintText: "enter description...",
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
                              Icons.calendar_month,
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
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

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
                              val == "" ? "Please enter start" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.punch_clock_rounded,
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
                            TimeOfDay? timeOfDay =
                                TimeOfDay(hour: 8, minute: 30);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
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
                              val == "" ? "Please enter end" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.punch_clock_rounded,
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
                            TimeOfDay? timeOfDay =
                                TimeOfDay(hour: 8, minute: 30);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
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

                        //button
                        Material(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Fluttertoast.showToast(msg: 'Uploading now..');
                                uploadItemImage();
                              }
                              setState(() {
                                defaultScreen();
                              });
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 28,
                              ),
                              child: Text(
                                "Upload Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImagedFileX == null ? defaultScreen() : uploadItemFromScreen();
  }

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classroom activity'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialogBoxForImagePickingAndCapturing();
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
                                        eachActivityItemRecord.activity_date!,
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
                                          deleteActivity(eachActivityItemRecord
                                              .activity_id!);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //ssasasasasa
                            },
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
                                  eachActivityItemRecord.activity_image!,
                                ),
                                imageErrorBuilder:
                                    (context, error, stackTraceError) {
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
