import 'package:crypto_app/presentation/pages/branding/branding_view.dart';
import 'package:crypto_app/presentation/pages/profile/profile_view.dart';
import 'package:crypto_app/presentation/pages/trading/trading_view.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const BrandingView(),
    const TradingView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}