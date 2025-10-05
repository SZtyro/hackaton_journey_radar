import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_scaffold.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/font_constants.dart';

enum RouteType {
  bus('Autobus', Icons.directions_bus, Colors.blue),
  tram('Tramwaj', Icons.tram, Colors.green),
  train('Pociąg', Icons.train, Colors.purple),
  metro('Metro', Icons.subway, Colors.orange);

  const RouteType(this.displayName, this.icon, this.backgroundColor);
  final String displayName;
  final IconData icon;
  final Color backgroundColor;
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String? _selectedRoute;
  String? _selectedStop;
  RouteType? _selectedRouteType;

  final ScrollController _scrollController = ScrollController();

  // Keys for scroll targets
  final GlobalKey _routeCardKey = GlobalKey();
  final GlobalKey _stopCardKey = GlobalKey();
  final GlobalKey _scheduleCardKey = GlobalKey();

  final List<Map<String, dynamic>> _routes = [
    {
      'id': '1',
      'name': 'Linia 1',
      'description': 'Dworzec Główny → Nowa Huta',
      'type': RouteType.bus,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'name': 'Linia 2',
      'description': 'Wawel → Kazimierz',
      'type': RouteType.tram,
      'color': Colors.green,
    },
    {
      'id': '3',
      'name': 'Linia 3',
      'description': 'Centrum → Lotnisko',
      'type': RouteType.bus,
      'color': Colors.blue,
    },
    {
      'id': '4',
      'name': 'Linia 4',
      'description': 'Okół → Podgórze',
      'type': RouteType.tram,
      'color': Colors.green,
    },
    {
      'id': '5',
      'name': 'SKM',
      'description': 'Kraków → Warszawa',
      'type': RouteType.train,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _stops = [
    {
      'id': 'main_station',
      'name': 'Dworzec Główny',
      'icon': Icons.train,
      'color': Colors.purple,
    },
    {
      'id': 'wawel',
      'name': 'Wawel',
      'icon': Icons.castle,
      'color': Colors.amber,
    },
    {
      'id': 'market_square',
      'name': 'Rynek Główny',
      'icon': Icons.location_city,
      'color': Colors.blue,
    },
    {
      'id': 'kazimierz',
      'name': 'Kazimierz',
      'icon': Icons.temple_buddhist,
      'color': Colors.green,
    },
    {
      'id': 'airport',
      'name': 'Lotnisko Kraków-Balice',
      'icon': Icons.flight,
      'color': Colors.orange,
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToWidget(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1, // Scroll to show the widget near the top
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Rozkład jazdy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Sprawdź rozkład jazdy',
              style: TextStyle(
                fontSize: FontConstants.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Wybierz linię i przystanek, aby zobaczyć najbliższe odjazdy',
              style: TextStyle(
                fontSize: FontConstants.fontSizeM,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.l),

            // Route type selection
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Typ transportu',
                      style: TextStyle(
                        fontSize: FontConstants.fontSizeM,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.m),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: AppSpacing.ms,
                        mainAxisSpacing: AppSpacing.ms,
                      ),
                      itemCount: RouteType.values.length,
                      itemBuilder: (context, index) {
                        final type = RouteType.values[index];
                        final isSelected = _selectedRouteType == type;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRouteType = type;
                              _selectedRoute =
                                  null; // Reset route when type changes
                              _selectedStop =
                                  null; // Reset stop when type changes
                            });
                            // Auto-scroll to route card after a short delay
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              _scrollToWidget(_routeCardKey);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? type.backgroundColor.withOpacity(0.12)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.ms),
                              border: Border.all(
                                color: isSelected
                                    ? type.backgroundColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: type.backgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    type.icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  type.displayName,
                                  style: TextStyle(
                                    fontSize: FontConstants.fontSizeXS,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? type.backgroundColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.m),

            // Route selection - only show if route type is selected
            if (_selectedRouteType != null) ...[
              Card(
                key: _routeCardKey,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wybierz linię',
                        style: TextStyle(
                          fontSize: FontConstants.fontSizeM,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: AppSpacing.m),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3.5,
                          mainAxisSpacing: AppSpacing.ms,
                        ),
                        itemCount: _routes
                            .where(
                                (route) => route['type'] == _selectedRouteType)
                            .length,
                        itemBuilder: (context, index) {
                          final filteredRoutes = _routes
                              .where((route) =>
                                  route['type'] == _selectedRouteType)
                              .toList();
                          final route = filteredRoutes[index];
                          final isSelected = _selectedRoute == route['id'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRoute = route['id'];
                                _selectedStop =
                                    null; // Reset stop when route changes
                              });
                              // Auto-scroll to stop card after a short delay
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _scrollToWidget(_stopCardKey);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? route['color'].withOpacity(0.12)
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.ms),
                                border: Border.all(
                                  color: isSelected
                                      ? route['color']
                                      : Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.3),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppSpacing.ms),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: route['color'],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        route['type'].icon,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.ms),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            route['name'],
                                            style: TextStyle(
                                              fontSize: FontConstants.fontSizeM,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? route['color']
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                            ),
                                          ),
                                          Text(
                                            route['description'],
                                            style: TextStyle(
                                              fontSize:
                                                  FontConstants.fontSizeXS,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Stop selection - only show if route is selected
              if (_selectedRoute != null) ...[
                Card(
                  key: _stopCardKey,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wybierz przystanek',
                          style: TextStyle(
                            fontSize: FontConstants.fontSizeM,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: AppSpacing.m),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 4.0,
                            mainAxisSpacing: AppSpacing.ms,
                          ),
                          itemCount: _stops.length,
                          itemBuilder: (context, index) {
                            final stop = _stops[index];
                            final isSelected = _selectedStop == stop['id'];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedStop = stop['id'];
                                });
                                // Auto-scroll to schedule card after a short delay
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  _scrollToWidget(_scheduleCardKey);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? stop['color'].withOpacity(0.12)
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.ms),
                                  border: Border.all(
                                    color: isSelected
                                        ? stop['color']
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(AppSpacing.ms),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: stop['color'],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          stop['icon'],
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.ms),
                                      Expanded(
                                        child: Text(
                                          stop['name'],
                                          style: TextStyle(
                                            fontSize: FontConstants.fontSizeM,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? stop['color']
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.m),

                // Schedule results
                if (_selectedStop != null) ...[
                  GestureDetector(
                    onTap: () {
                      // Scroll to bottom of the page
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _scrollToBottom();
                      });
                    },
                    child: Card(
                      key: _scheduleCardKey,
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                SizedBox(width: AppSpacing.ms),
                                Text(
                                  'Najbliższe odjazdy',
                                  style: TextStyle(
                                    fontSize: FontConstants.fontSizeM,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.m),
                            _buildScheduleList(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.m),

                  // Quick actions
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Szybkie akcje',
                            style: TextStyle(
                              fontSize: FontConstants.fontSizeM,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: AppSpacing.m),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Znaleziono najbliższe przystanki!'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.my_location),
                                  label: const Text('Moja lokalizacja'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppSpacing.ms),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.ms),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Otwieranie ulubionych przystanków...'),
                                        backgroundColor: Colors.blue,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.favorite),
                                  label: const Text('Ulubione'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppSpacing.ms),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    // Mock schedule data
    final scheduleData = [
      {
        'time': '14:25',
        'destination': 'Dworzec Główny',
        'delay': 'Na czas',
        'status': 'onTime'
      },
      {
        'time': '14:35',
        'destination': 'Dworzec Główny',
        'delay': '+2 min',
        'status': 'delayed'
      },
      {
        'time': '14:45',
        'destination': 'Dworzec Główny',
        'delay': 'Na czas',
        'status': 'onTime'
      },
      {
        'time': '14:55',
        'destination': 'Dworzec Główny',
        'delay': '+1 min',
        'status': 'delayed'
      },
    ];

    return Column(
      children: scheduleData.map((departure) {
        final isOnTime = departure['status'] == 'onTime';
        final isDelayed = departure['status'] == 'delayed';

        Color statusColor;
        IconData statusIcon;

        if (isOnTime) {
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
        } else if (isDelayed) {
          statusColor = Colors.orange;
          statusIcon = Icons.schedule;
        } else {
          statusColor = Colors.grey;
          statusIcon = Icons.info;
        }

        return Container(
          margin: EdgeInsets.only(bottom: AppSpacing.ms),
          padding: EdgeInsets.all(AppSpacing.ms),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSpacing.ms),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.ms),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      departure['time']!,
                      style: TextStyle(
                        fontSize: FontConstants.fontSizeM,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      departure['destination']!,
                      style: TextStyle(
                        fontSize: FontConstants.fontSizeXS,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  departure['delay']!,
                  style: TextStyle(
                    fontSize: FontConstants.fontSizeXS,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
