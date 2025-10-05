import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String? _selectedRoute;
  String? _selectedStop;

  final List<AppDropdownItem<String>> _routes = [
    AppDropdownItem(
      value: '1',
      text: 'Linia 1 - Dworzec Główny → Nowa Huta',
      icon: Icons.directions_bus,
    ),
    AppDropdownItem(
      value: '2',
      text: 'Linia 2 - Wawel → Kazimierz',
      icon: Icons.directions_bus,
    ),
    AppDropdownItem(
      value: '3',
      text: 'Linia 3 - Centrum → Lotnisko',
      icon: Icons.directions_bus,
    ),
    AppDropdownItem(
      value: '4',
      text: 'Linia 4 - Okół → Podgórze',
      icon: Icons.directions_bus,
    ),
  ];

  final List<AppDropdownItem<String>> _stops = [
    AppDropdownItem(
      value: 'main_station',
      text: 'Dworzec Główny',
      icon: Icons.train,
    ),
    AppDropdownItem(
      value: 'wawel',
      text: 'Wawel',
      icon: Icons.castle,
    ),
    AppDropdownItem(
      value: 'market_square',
      text: 'Rynek Główny',
      icon: Icons.location_city,
    ),
    AppDropdownItem(
      value: 'kazimierz',
      text: 'Kazimierz',
      icon: Icons.temple_buddhist,
    ),
    AppDropdownItem(
      value: 'airport',
      text: 'Lotnisko Kraków-Balice',
      icon: Icons.flight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rozkład jazdy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AppText(
              'Sprawdź rozkład jazdy',
              variant: AppTextVariant.headline,
            ),
            SizedBox(height: AppSpacing.s),
            AppText(
              'Wybierz linię i przystanek, aby zobaczyć najbliższe odjazdy',
              variant: AppTextVariant.body,
            ),
            SizedBox(height: AppSpacing.l),

            // Route selection
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Wybierz linię',
                      variant: AppTextVariant.title,
                    ),
                    SizedBox(height: AppSpacing.s),
                    AppDropdown<String>(
                      label: 'Linia autobusowa',
                      hint: 'Wybierz linię',
                      value: _selectedRoute,
                      onChanged: (value) {
                        setState(() {
                          _selectedRoute = value;
                          _selectedStop = null; // Reset stop when route changes
                        });
                      },
                      items: _routes,
                      variant: AppDropdownVariant.outlined,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.m),

            // Stop selection
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Wybierz przystanek',
                      variant: AppTextVariant.title,
                    ),
                    SizedBox(height: AppSpacing.s),
                    AppDropdown<String>(
                      label: 'Przystanek',
                      hint: 'Wybierz przystanek',
                      value: _selectedStop,
                      onChanged: _selectedRoute != null
                          ? (value) {
                              setState(() {
                                _selectedStop = value;
                              });
                            }
                          : null,
                      items: _stops,
                      variant: AppDropdownVariant.outlined,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.m),

            // Schedule results
            if (_selectedRoute != null && _selectedStop != null) ...[
              AppCard(
                variant: AppCardVariant.elevated,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Najbliższe odjazdy',
                        variant: AppTextVariant.title,
                      ),
                      SizedBox(height: AppSpacing.s),
                      _buildScheduleList(),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: AppSpacing.l),

            // Quick actions
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Szybkie akcje',
                      variant: AppTextVariant.title,
                    ),
                    SizedBox(height: AppSpacing.s),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Moja lokalizacja',
                            variant: AppButtonVariant.primary,
                            icon: Icons.my_location,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Znaleziono najbliższe przystanki!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: AppButton(
                            text: 'Ulubione',
                            variant: AppButtonVariant.secondary,
                            icon: Icons.favorite,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Otwieranie ulubionych przystanków...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    // Mock schedule data
    final scheduleData = [
      {'time': '14:25', 'destination': 'Dworzec Główny', 'delay': 'Na czas'},
      {'time': '14:35', 'destination': 'Dworzec Główny', 'delay': '+2 min'},
      {'time': '14:45', 'destination': 'Dworzec Główny', 'delay': 'Na czas'},
      {'time': '14:55', 'destination': 'Dworzec Główny', 'delay': '+1 min'},
    ];

    return Column(
      children: scheduleData.map((departure) {
        final isOnTime = departure['delay'] == 'Na czas';
        final isDelayed = departure['delay']!.contains('+');

        return Container(
          margin: EdgeInsets.only(bottom: AppSpacing.s),
          padding: EdgeInsets.all(AppSpacing.s),
          decoration: BoxDecoration(
            color: isOnTime
                ? Colors.green.withOpacity(0.1)
                : isDelayed
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            border: Border.all(
              color: isOnTime
                  ? Colors.green
                  : isDelayed
                      ? Colors.orange
                      : Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              AppIcon(
                icon: Icons.schedule,
                variant: isOnTime
                    ? AppIconVariant.success
                    : isDelayed
                        ? AppIconVariant.warning
                        : AppIconVariant.muted,
              ),
              SizedBox(width: AppSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      departure['time']!,
                      variant: AppTextVariant.title,
                    ),
                    AppText(
                      departure['destination']!,
                      variant: AppTextVariant.caption,
                    ),
                  ],
                ),
              ),
              AppText(
                departure['delay']!,
                variant: isOnTime
                    ? AppTextVariant.success
                    : isDelayed
                        ? AppTextVariant.warning
                        : AppTextVariant.caption,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
