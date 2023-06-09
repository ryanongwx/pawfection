import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:pawfection/volunteer/v_profile_screen.dart';
import 'package:pawfection/volunteer/v_dashboard_screen.dart';

class VolunteerView extends StatefulWidget {
  const VolunteerView({Key? key, required this.tab}) : super(key: key);

  final int tab;

  @override
  State<VolunteerView> createState() => _VolunteerViewState();
}

class _VolunteerViewState extends State<VolunteerView> {
  var _pageController = PageController();
  late List<Widget> bottomBarPages;
  int maxCount = 2;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.tab);

    /// widget list
    bottomBarPages = [
      const VDashboardScreen(),
      VProfileScreen(),
    ];
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
