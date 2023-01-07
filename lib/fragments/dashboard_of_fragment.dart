import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../users/userPreferences/current_user.dart';
import '../fragments/home_fragment_screen.dart';
import '../fragments/profile_fragment_screen.dart';
import '../fragments/attendance_fragment_screen.dart';
import '../fragments/menu_food_fragment_screen.dart';

class DashBoardOfFragment extends StatelessWidget {
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    MenuFragmentScreen(),
    AttendanceFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  List _navgationButtonProperties = [
    {
      'active_icon': Icons.home,
      'non_active_icon': Icons.home_outlined,
      'label': 'Home'
    },
    {
      'active_icon': FontAwesomeIcons.bowlFood,
      'non_active_icon': FontAwesomeIcons.bowlRice,
      'label': 'Food'
    },
    {
      'active_icon': FontAwesomeIcons.children,
      'non_active_icon': FontAwesomeIcons.children,
      'label': 'Children'
    },
    {
      'active_icon': Icons.person,
      'non_active_icon': Icons.person_outline,
      'label': 'Profile'
    },
  ];

  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
              () => _fragmentScreens[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              backgroundColor: Colors.lightBlue,
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
              items: List.generate(4, (index) {
                var navBtnProperty = _navgationButtonProperties[index];
                return BottomNavigationBarItem(
                    backgroundColor: Colors.lightBlue,
                    icon: Icon(navBtnProperty['non_active_icon']),
                    activeIcon: Icon(navBtnProperty['active_icon']),
                    label: navBtnProperty['label']);
              }),
            ),
          ),
        );
      },
    );
  }
}
