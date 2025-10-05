import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:journey_radar_mobile/app_ui/app_scaffold.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/font_constants.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/theme/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Ustawienia motywu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider.value(
        value: getIt<ThemeCubit>(),
        child: const SettingsContent(),
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tryb motywu',
                        style: TextStyle(
                          fontSize: FontConstants.fontSizeM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.m),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text('System'),
                            icon: Icon(Icons.brightness_auto),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text('Jasny'),
                            icon: Icon(Icons.brightness_high),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text('Ciemny'),
                            icon: Icon(Icons.brightness_2),
                          ),
                        ],
                        selected: {state.mode},
                        onSelectionChanged: (Set<ThemeMode> selection) {
                          context.read<ThemeCubit>().setMode(selection.first);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.m),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kolory dynamiczne',
                        style: TextStyle(
                          fontSize: FontConstants.fontSizeM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      SwitchListTile(
                        title: const Text('Użyj kolorów systemowych'),
                        subtitle: const Text(
                          'Dynamiczne kolory nie są dostępne w tej wersji',
                        ),
                        value: false,
                        onChanged: null,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kolor wiodący',
                        style: TextStyle(
                          fontSize: FontConstants.fontSizeM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.m),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppSpacing.ms),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          title: const Text('Wybierz kolor'),
                          subtitle:
                              Text('Aktualny: ${_colorToHex(state.seed)}'),
                          trailing: Container(
                            width: AppSpacing.xl,
                            height: AppSpacing.xl,
                            decoration: BoxDecoration(
                              color: state.seed,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                                width: AppSpacing.xxs,
                              ),
                            ),
                          ),
                          onTap: () => _showColorPicker(context),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.m,
                            vertical: AppSpacing.xs,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Theme Information Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                      ),
                      SizedBox(width: AppSpacing.ms),
                      Expanded(
                        child: Text(
                          'Zmiany motywu są zapisywane automatycznie i będą widoczne w całej aplikacji.',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: FontConstants.fontSizeXS,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context) {
    final currentColor = context.read<ThemeCubit>().state.seed;
    Color selectedColor = currentColor;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Wybierz kolor',
            style: TextStyle(
              fontSize: FontConstants.fontSizeM,
              fontWeight: FontWeight.bold,
            ),
          ),
          contentPadding: EdgeInsets.all(AppSpacing.m),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.ms),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.ms),
                    child: ColorPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      enableAlpha: false,
                      displayThumbColor: true,
                      paletteType: PaletteType.hslWithHue,
                      pickerAreaHeightPercent: 0.7,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.m),
                Container(
                  padding: EdgeInsets.all(AppSpacing.ms),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.ms),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppSpacing.xl,
                        height: AppSpacing.xl,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: AppSpacing.xxs,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.ms),
                      Expanded(
                        child: Text(
                          'Wybrany kolor: ${_colorToHex(selectedColor)}',
                          style: TextStyle(
                            fontSize: FontConstants.fontSizeXS,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.all(AppSpacing.m),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
              ),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () {
                context.read<ThemeCubit>().setSeed(selectedColor);
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
              ),
              child: const Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
