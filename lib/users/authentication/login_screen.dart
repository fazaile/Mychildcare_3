import 'dart:convert';

import 'package:Mychildcare/admin/admin_login_screen.dart';
import 'package:Mychildcare/admin/teacher/teacher_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Mychildcare/fragments/dashboard_of_fragment.dart';
import '../userPreferences/user_preferences.dart';
import './signup_screen.dart';
import '../model/user.dart';
import 'package:Mychildcare/api_collection/api_connection.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUserNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          //tengok kat php kene sama warna oren
          'user_email': emailController.text.trim(),
          'user_password': passwordController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(
              msg: 'Congratulations, you are signup succesfully');
          User userInfo = User.fromJson(resBodyOfLogin["userData"]);

//save userInfo to local storage using share
          await RememberUserPrefs.storeUserInfo(userInfo);

          Future.delayed(Duration(milliseconds: 2000), () {
            Get.to(DashBoardOfFragment());
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
                          child: Column(children: [
                            const Text(
                              'User Login',
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
                                    validator: (val) =>
                                        val == "" ? "Please write email" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "email..",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.white60),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
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
                                  ),
                                  const SizedBox(height: 18),

                                  //button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          loginUserNow();
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
                                Text('Dont have and account?'),
                                TextButton(
                                    onPressed: () {
                                      Get.to(SignUpScreen());
                                    },
                                    child: const Text(
                                      'Register Here',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ))
                              ],
                            ),

                            const Text(
                              'or',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),

                            //are you an Admin-button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Please click here if you are'),
                                // TextButton(
                                //   onPressed: () {
                                //     Get.to(AdminLoginScreen());
                                //   },
                                //   child: const Text(
                                //     'Admin',
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 16,
                                //     ),
                                //   ),
                                // ),
                                // Text('or'),
                                TextButton(
                                    onPressed: () {
                                      Get.to(TeacherLoginScreen());
                                    },
                                    child: const Text(
                                      'teacher',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ))
                              ],
                            ),
                          ]),
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
