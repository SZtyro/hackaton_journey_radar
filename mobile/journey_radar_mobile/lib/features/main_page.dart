import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/features/home_page.dart';
import 'package:journey_radar_mobile/features/map_page.dart';
import 'package:journey_radar_mobile/features/schedule_page.dart';
import 'package:journey_radar_mobile/features/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
    const SchedulePage(),
    const SettingsPage(),
  ];

  final List<AppBottomNavigationItem> _navigationItems = [
    AppBottomNavigationItem(
      icon: const Icon(Icons.home_outlined),
      activeIcon: const Icon(Icons.home),
      label: 'Strona główna',
      tooltip: 'Przejdź do strony głównej',
    ),
    AppBottomNavigationItem(
      icon: const Icon(Icons.map_outlined),
      activeIcon: const Icon(Icons.map),
      label: 'Mapa',
      tooltip: 'Otwórz mapę Krakowa',
    ),
    AppBottomNavigationItem(
      icon: const Icon(Icons.schedule_outlined),
      activeIcon: const Icon(Icons.schedule),
      label: 'Rozkład',
      tooltip: 'Rozkład jazdy',
    ),
    AppBottomNavigationItem(
      icon: const Icon(Icons.settings_outlined),
      activeIcon: const Icon(Icons.settings),
      label: 'Ustawienia',
      tooltip: 'Ustawienia aplikacji',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navigationItems,
        variant: AppBottomNavigationVariant.default_,
      ),
    );
  }
}
