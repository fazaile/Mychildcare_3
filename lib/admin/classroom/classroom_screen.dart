import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var imageLink = '';

  var formKey = GlobalKey<FormState>();
  var classroomNameController = TextEditingController();
  var classroomCapacityController = TextEditingController();

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

//delete method
  deleteChildrenItem(int classroom_id) async {
    try {
      var res = await http.post(Uri.parse(API.deleteClassroom), body: {
        "classroom_id": classroom_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if (responseBodyFromDeleteCart["success"] == true) {
          setState(() {
            getAllClassroomItem();
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

//defaultScreen methods
  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() {
      pickedImageXFile;
    });
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();

    setState(() {
      pickedImageXFile;
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

  //uploadItemFormScreen methods
  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "55eaa7530afc3ed";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
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
      print('hskjnkakjkslaasadxsaads');
      print(classroomNameController.text);
      print(classroomCapacityController.text);
      var response = await http.post(Uri.parse(API.uploadClassroom), body: {
        'classroom_id': '1',
        //drop down box sini
        'classroom_name': classroomNameController.text,
        'classroom_capacity': classroomCapacityController.text,
        'classroom_image': imageLink.toString(),
      });
      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success'] = true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImageXFile = null;
            classroomNameController.clear();
            classroomCapacityController.clear();
            getAllClassroomItem();
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
    return pickedImageXFile == null
        ? defaultScreen(context)
        : uploadItemFromScreen();
  }

  // Widget defaultScreen(context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Children'),
  //       actions: <Widget>[
  //         IconButton(
  //           onPressed: () {
  //             Get.to(ClassRoomSaveScreen());
  //           },
  //           icon: Icon(Icons.add),
  //         ),
  //       ],
  //     ),
  //     body: allItemWidget(context),
  //   );
  // }

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
                                        eachItemClassRoomRecord.classroom_name!,
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
                                        deleteChildrenItem(
                                            eachItemClassRoomRecord
                                                .classroom_id!);
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
                              placeholder:
                                  const AssetImage("images/place_holder_1.png"),
                              image: NetworkImage(
                                eachItemClassRoomRecord.classroom_image!,
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
        });
  }

  Widget defaultScreen(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classroom'),
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

  Widget uploadItemFromScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
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
        title: const Text('Upload Classroom Form'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              classroomNameController.clear();
              classroomCapacityController.clear();
              getAllClassroomItem();
            });

            Get.to(ClassroomScreen());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Fluttertoast.showToast(msg: "Uploading now...");

                Get.to(defaultScreen(context));
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
                File(pickedImageXFile!.path),
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
              color: Colors.white24,
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
                          controller: classroomNameController,
                          validator: (val) =>
                              val == "" ? "Please enter classroom name" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.black,
                            ),
                            hintText: "Enter classroom name...",
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
                          controller: classroomCapacityController,
                          validator: (val) => val == ""
                              ? "Please enter classroom capacity"
                              : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.black,
                            ),
                            hintText: "enter classroom capacity...",
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

                        // DropdownWidget(),

                        // DropDownTextField(
                        //   // initialValue: "name4",
                        //   controller: _cnt,
                        //   clearOption: true,
                        //   enableSearch: true,
                        //   clearIconProperty: IconProperty(color: Colors.green),
                        //   searchDecoration:
                        //       const InputDecoration(hintText: "Choice Parent"),
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "Required field";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        //   dropDownItemCount: 6,

                        //   dropDownList: const [
                        //     DropDownValueModel(name: 'name1', value: "value1"),
                        //     DropDownValueModel(
                        //         name: 'name2',
                        //         value: "value2",
                        //         toolTipMsg:
                        //             "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                        //     DropDownValueModel(name: 'name3', value: "value3"),
                        //     DropDownValueModel(
                        //         name: 'name4',
                        //         value: "value4",
                        //         toolTipMsg:
                        //             "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                        //     DropDownValueModel(name: 'name5', value: "value5"),
                        //     DropDownValueModel(name: 'name6', value: "value6"),
                        //     DropDownValueModel(name: 'name7', value: "value7"),
                        //     DropDownValueModel(name: 'name8', value: "value8"),
                        //   ],
                        //   onChanged: (val) {},
                        // ),
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
                                defaultScreen(context);
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
}
