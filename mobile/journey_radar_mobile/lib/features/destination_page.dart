import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/services/location_service.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  final LocationService _locationService = LocationService();
  final TextEditingController _destinationController = TextEditingController();

  String? _selectedLine;
  String? _currentStop;
  String? _destinationStop;
  bool _isLoadingLocation = false;
  bool _isLoadingStops = false;

  // Mock data for demonstration
  final List<String> _availableLines = [
    'Linia 1 - Dworzec Główny - Bronowice',
    'Linia 2 - Dworzec Główny - Nowa Huta',
    'Linia 3 - Dworzec Główny - Podgórze',
    'Linia 4 - Dworzec Główny - Bieżanów',
    'Linia 5 - Dworzec Główny - Mistrzejowice',
    'Linia 6 - Dworzec Główny - Krowodrza',
    'Linia 7 - Dworzec Główny - Łagiewniki',
    'Linia 8 - Dworzec Główny - Wola Duchacka',
  ];

  final List<String> _currentLocationStops = [
    'Dworzec Główny',
    'Plac Centralny',
    'Rondo Mogilskie',
    'Uniwersytet Jagielloński',
    'Rynek Główny',
  ];

  final List<String> _destinationStops = [
    'Dworzec Główny',
    'Plac Centralny',
    'Rondo Mogilskie',
    'Uniwersytet Jagielloński',
    'Rynek Główny',
    'Stary Kleparz',
    'Teatr Słowackiego',
    'Plac Bohaterów Getta',
    'Kazimierz',
    'Podgórze',
    'Nowa Huta',
    'Bronowice',
    'Bieżanów',
    'Mistrzejowice',
    'Krowodrza',
    'Łagiewniki',
    'Wola Duchacka',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      final isLocationEnabled =
          await _locationService.isLocationServiceEnabled();

      if (!isLocationEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        _showLocationErrorDialog(
            'Usługi lokalizacji są wyłączone. Włącz lokalizację w ustawieniach urządzenia.');
        return;
      }

      // Request location permission
      final hasPermission = await _locationService.requestLocationPermission();

      if (!hasPermission) {
        setState(() {
          _isLoadingLocation = false;
        });
        _showLocationErrorDialog(
            'Aplikacja potrzebuje dostępu do lokalizacji, aby znaleźć najbliższe przystanki.');
        return;
      }

      // Get current location
      final position = await _locationService.getCurrentLocation();

      if (position != null) {
        // In a real implementation, you would:
        // 1. Use the position to find nearby stops via API
        // 2. Calculate distances to all stops
        // 3. Return the closest stops

        // For now, simulate finding the closest stop
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          _currentStop =
              _currentLocationStops.first; // This would be the closest stop
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _isLoadingLocation = false;
        });
        _showLocationErrorDialog(
            'Nie można określić aktualnej lokalizacji. Sprawdź ustawienia lokalizacji.');
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      _showLocationErrorDialog('Błąd podczas pobierania lokalizacji: $e');
    }
  }

  Future<void> _loadStopsForLine(String line) async {
    setState(() {
      _isLoadingStops = true;
    });

    try {
      // Simulate API call to load stops for selected line
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoadingStops = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStops = false;
      });
      // Handle error
    }
  }

  void _onLineSelected(String? line) {
    setState(() {
      _selectedLine = line;
      _destinationStop = null; // Reset destination
    });

    if (line != null) {
      _loadStopsForLine(line);
    }
  }

  void _onDestinationSelected(String? destination) {
    setState(() {
      _destinationStop = destination;
    });
  }

  void _showLocationErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Błąd lokalizacji'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadCurrentLocation();
            },
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }

  void _onSearchDestination() {
    if (_destinationController.text.isNotEmpty) {
      // Filter stops based on search query
      final filteredStops = _destinationStops
          .where((stop) => stop
              .toLowerCase()
              .contains(_destinationController.text.toLowerCase()))
          .toList();

      if (filteredStops.isNotEmpty) {
        _onDestinationSelected(filteredStops.first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Wybierz cel podróży'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Location Section
            _buildCurrentLocationSection(theme, colorScheme),

            SizedBox(height: AppSpacing.l),

            // Line Selection Section
            _buildLineSelectionSection(theme, colorScheme),

            SizedBox(height: AppSpacing.l),

            // Destination Selection Section
            if (_selectedLine != null) ...[
              _buildDestinationSection(theme, colorScheme),
              SizedBox(height: AppSpacing.l),
            ],

            // Search and Continue Button
            if (_destinationStop != null) ...[
              _buildActionButtons(theme, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationSection(
      ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.my_location,
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: AppSpacing.s),
                Text(
                  'Twoja lokalizacja',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s),
            if (_isLoadingLocation)
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: AppSpacing.s),
                  const Text('Wyszukiwanie najbliższego przystanku...'),
                ],
              )
            else if (_currentStop != null)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        _currentStop!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                'Nie można określić lokalizacji',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineSelectionSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wybierz linię',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.s),
        AppTextField(
          controller: TextEditingController(text: _selectedLine ?? ''),
          hint: 'Wybierz linię komunikacji miejskiej',
          readOnly: true,
          onTap: () => _showLineSelectionDialog(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          variant: AppTextFieldVariant.filled,
        ),
      ],
    );
  }

  Widget _buildDestinationSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wybierz przystanek docelowy',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.s),

        // Search field
        AppTextField(
          controller: _destinationController,
          hint: 'Wyszukaj przystanek...',
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _destinationStop = null;
              });
            }
          },
          onSubmitted: (_) => _onSearchDestination(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchDestination,
          ),
          variant: AppTextFieldVariant.filled,
        ),

        SizedBox(height: AppSpacing.s),

        // Stops list
        if (_isLoadingStops)
          Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: CircularProgressIndicator(),
            ),
          )
        else
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _destinationStops.length,
              itemBuilder: (context, index) {
                final stop = _destinationStops[index];
                final isSelected = _destinationStop == stop;

                return ListTile(
                  leading: Icon(
                    Icons.directions_bus,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    stop,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: colorScheme.primary,
                        )
                      : null,
                  onTap: () => _onDestinationSelected(stop),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        AppButton(
          text: 'Pokaż trasę',
          onPressed: _destinationStop != null
              ? () {
                  // Navigate to route/map view
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Trasa: $_currentStop → $_destinationStop'),
                      backgroundColor: colorScheme.primary,
                    ),
                  );
                }
              : null,
          variant: AppButtonVariant.primary,
          size: AppButtonSize.large,
          isFullWidth: true,
          icon: Icons.directions,
        ),
        SizedBox(height: AppSpacing.s),
        AppButton(
          text: 'Wyczyść wybór',
          onPressed: () {
            setState(() {
              _selectedLine = null;
              _destinationStop = null;
              _destinationController.clear();
            });
          },
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.medium,
          isFullWidth: true,
        ),
      ],
    );
  }

  void _showLineSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wybierz linię'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableLines.length,
            itemBuilder: (context, index) {
              final line = _availableLines[index];
              final isSelected = _selectedLine == line;

              return ListTile(
                leading: Icon(
                  Icons.directions_bus,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                title: Text(line),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  _onLineSelected(line);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anuluj'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
}
