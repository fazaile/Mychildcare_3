import 'dart:convert';
import 'dart:io';

import 'package:Mychildcare/admin/children/admin_edit_item_screen.dart';
import 'package:Mychildcare/admin/admin_main_menu_screen.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';
import 'package:Mychildcare/users/model/children.dart';
import 'package:Mychildcare/users/model/classroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import 'package:Mychildcare/admin/admin_login_screen.dart';

class AdminChildrenScreen extends StatefulWidget {
  const AdminChildrenScreen({super.key});

  @override
  State<AdminChildrenScreen> createState() => _AdminChildrenScreenState();
}

class _AdminChildrenScreenState extends State<AdminChildrenScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  //  var ratingController = TextEditingController();
  // var priceController = TextEditingController();
  // var tagsController = TextEditingController();
  // var sizesController = TextEditingController();
  // var colorsController = TextEditingController();
  // var descriptionController = TextEditingController();
  var imageLink = '';

  Future<List<Children>> getAllChildrenItem() async {
    List<Children> allChildrenItemList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllChildren));

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

  deleteChildrenItem(int children_id) async {
    try {
      var res = await http.post(Uri.parse(API.deleteChildren), body: {
        "children_id": children_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if (responseBodyFromDeleteCart["success"] == true) {
          setState(() {
            getAllChildrenItem();
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
  //default screen methods ends here

  Widget defaultScreen(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Children'),
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

//select all children
  allItemWidget(context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: getAllChildrenItem(),
          builder: (context, AsyncSnapshot<List<Children>> dataSnapShot) {
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
                  Children eachChildrenItemRecord = dataSnapShot.data![index];

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
                                          eachChildrenItemRecord.name!,
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
                                            Get.to(AdminEditItemScreen());
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteChildrenItem(
                                              eachChildrenItemRecord
                                                  .children_id!);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //image clothes
                          GestureDetector(
                            onTap: () {
                              Get.to(AdminMainMenuScreen());
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
                                  eachChildrenItemRecord.image!,
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
      var response = await http.post(Uri.parse(API.uploadNewChildren), body: {
        'children_id': '1',
        //drop down box sini
        'name': nameController.text.trim().toString(),
        'age': ageController.text.trim().toString(),
        'image': imageLink.toString()
      });
      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success'] = true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ageController.clear();
            getAllChildrenItem();
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

  //uploadItemFormScreen methods ends here

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
        title: const Text('Upload Children Form'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              nameController.clear();
              ageController.clear();
            });

            Get.to(AdminChildrenScreen());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Fluttertoast.showToast(msg: "Uploading now...");

                defaultScreen(context);
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
                          controller: nameController,
                          validator: (val) =>
                              val == "" ? "Please enter child name" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.black,
                            ),
                            hintText: "item child name...",
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
                          controller: ageController,
                          validator: (val) =>
                              val == "" ? "Please enter child age" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.black,
                            ),
                            hintText: "item age...",
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

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null
        ? defaultScreen(context)
        : uploadItemFromScreen();
  }
}
