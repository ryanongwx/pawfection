import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'package:pawfection/managerscreens/m_dashboard_screen.dart';
import 'package:pawfection/managerscreens/m_pet_screen.dart';
import 'package:pawfection/managerscreens/m_volunteerlist_screen.dart';

class ManagerView extends StatefulWidget {
  const ManagerView({super.key, required this.tab});

  final int tab;

  @override
  State<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  var _pageController = PageController();

  int maxCount = 3;

  /// widget list
  final List<Widget> bottomBarPages = [
    const MPetScreen(),
    const MDashboardScreen(),
    const MVolunteerListScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Icons.pets,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.pets,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Pets',
                ),
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
                    Icons.task,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.task,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Tasks',
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
