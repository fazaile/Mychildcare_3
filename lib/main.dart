import 'package:Mychildcare/fragments/dashboard_of_fragment.dart';
import 'package:Mychildcare/users/authentication/login_screen.dart';
import 'package:Mychildcare/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51MPZqCAc9yZN9ylZGkexNOGrGaBQdIcFtGkuhE4ebiyCdqSYhjf7nXs3t8z0QkzGCAwMUh09tmlci1GnbpCI8ymy00F4uzehEP';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: RememberUserPrefs.readUserInfo(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.data == null) {
              return LoginScreen();
            } else {
              return DashBoardOfFragment();
            }
          }),
    );
  }
}
