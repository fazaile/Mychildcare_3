import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Mychildcare/fragments/dashboard_of_fragment.dart';
import 'teacher_signup_screen.dart';
import 'package:Mychildcare/users/model/teacher.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';
import 'package:Mychildcare/admin/admin_login_screen.dart';
import 'package:Mychildcare/admin/teacher/teacher_classroom_selection.dart';
import 'package:Mychildcare/admin/teacher/teacher_login_screen.dart';
import './teacher_classroom_selection.dart';
import 'package:Mychildcare/users/authentication/login_screen.dart';
import 'package:Mychildcare/users/model/children.dart';

class TeacherLoginScreen extends StatefulWidget {
  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  logInTeacherNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.teacherLogin),
        body: {
          //tengok kat php kene sama warna oren
          'teacher_email': emailController.text.trim(),
          'teacher_password': passwordController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(
              msg: 'Congratulations, you are signup succesfully');
          Teacher teacherInfo = Teacher.fromJson(resBodyOfLogin["teacherData"]);

          Future.delayed(Duration(milliseconds: 2000), () {
            //tumpang sini dulu.sbjksxjkaxknajnxjlkkjxnkmznxcmnznjxcclnxznzxlcxzczxzcxzcxzxcz
            Get.to(TeacherClassroomSelection());
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Please write correct password or email,try again');
        }
      }
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, cons) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: cons.maxHeight,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //login screen header
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 285,
                      child: Image.asset('images/logo.jpg'),
                    ),
                    //login screen sig-in form
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
                              const Text(
                                'Teacher Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 18),
                              //email-password-login btn
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    //email
                                    TextFormField(
                                      controller: emailController,
                                      validator: (val) => val == ""
                                          ? "Please write email"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.black,
                                        ),
                                        hintText: "email..",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.white60),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    //password
                                    Obx(
                                      () => TextFormField(
                                        controller: passwordController,
                                        obscureText: isObsecure.value,
                                        validator: (val) => val == ""
                                            ? "Please write password"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.vpn_key_sharp,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: Obx(
                                            () => GestureDetector(
                                              onTap: () {
                                                isObsecure.value =
                                                    !isObsecure.value;
                                              },
                                              child: Icon(
                                                isObsecure.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          hintText: "password..",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white60),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),

                                    //button
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            logInTeacherNow();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 16,
                              ),

                              //dont have an account button-button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Not a teacher please?'),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(LoginScreen());
                                },
                                child: const Text(
                                  'Click Here',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
