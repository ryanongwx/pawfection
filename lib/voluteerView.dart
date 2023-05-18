import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:pawfection/Volunteer%20Screens/mprofileScreen.dart';
import 'package:pawfection/Volunteer%20Screens/vdashboardScreen.dart';

import 'package:searchable_listview/searchable_listview.dart';

class VolunteerView extends StatefulWidget {
  const VolunteerView({super.key});

  @override
  State<VolunteerView> createState() => _VolunteerViewState();
}

class _VolunteerViewState extends State<VolunteerView> {
  final _pageController = PageController(initialPage: 1);

  int maxCount = 2;

  /// widget list
  final List<Widget> bottomBarPages = [
    const VDashboardScreen(),
    const VProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.dashboard,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.dashboard,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Dashboard',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.account_circle,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.account_circle,
                    color: Colors.redAccent,
                  ),
                  itemLabel: 'Profile',
                ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            )
          : null,
    );
  }
}
