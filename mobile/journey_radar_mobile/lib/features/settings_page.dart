import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/theme/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia motywu'),
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
              // Theme Mode Section
              AppText(
                'Tryb motywu',
                variant: AppTextVariant.title,
              ),
              SizedBox(height: AppSpacing.xs),
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

              SizedBox(height: AppSpacing.l),

              // Dynamic Colors Section (disabled for now)
              AppText(
                'Kolory dynamiczne',
                variant: AppTextVariant.title,
              ),
              SizedBox(height: AppSpacing.xs),
              SwitchListTile(
                title: const Text('Użyj kolorów systemowych'),
                subtitle: const Text(
                  'Dynamiczne kolory nie są dostępne w tej wersji',
                ),
                value: false,
                onChanged: null,
              ),

              SizedBox(height: AppSpacing.l),

              // Custom Color Section
              AppText(
                'Kolor wiodący',
                variant: AppTextVariant.title,
              ),
              SizedBox(height: AppSpacing.xs),
              ListTile(
                title: const Text('Wybierz kolor'),
                subtitle: Text('Aktualny: ${_colorToHex(state.seed)}'),
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
              ),

              SizedBox(height: AppSpacing.l),

              // Preview Section
              AppText(
                'Podgląd',
                variant: AppTextVariant.title,
              ),
              SizedBox(height: AppSpacing.xs),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    children: [
                      AppButton(
                        text: 'Przykładowy przycisk',
                        onPressed: () {},
                        variant: AppButtonVariant.primary,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      AppButton(
                        text: 'Przykładowy przycisk',
                        onPressed: () {},
                        variant: AppButtonVariant.secondary,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      AppText(
                        'Przykładowy tekst',
                        variant: AppTextVariant.body,
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
          title: const Text('Wybierz kolor'),
          content: SingleChildScrollView(
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
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () {
                context.read<ThemeCubit>().setSeed(selectedColor);
                Navigator.of(context).pop();
              },
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
