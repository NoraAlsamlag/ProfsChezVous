import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/layout/BottomNavigationBar.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:profschezvousfrontend/pages/home/home.dart';
import 'package:profschezvousfrontend/pages/profile.dart';

class EcranPrincipal extends StatefulWidget {
  const EcranPrincipal();

  @override
  _EcranPrincipalState createState() => _EcranPrincipalState();
}

class _EcranPrincipalState extends State<EcranPrincipal> {
  int _currentIndex = 0;
  late PageController _pageController;
  int _notificationCount = 0; // New property to hold notification count

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    // Example: Initialize notification count
    _notificationCount = 3; // Set initial notification count
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomePage(),
          Container(),
          ProfilePage(token: '${user.token}'),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        notificationCount: _notificationCount, // Pass notification count
      ),
    );
  }
}
