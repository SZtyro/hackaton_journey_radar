import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetOnTime'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'Witaj w GetOnTime!',
              variant: AppTextVariant.headline,
              size: AppTextSize.large,
            ),
            SizedBox(height: AppSpacing.m),
            AppText(
              'Aplikacja z nowym systemem motywowania Material 3',
              variant: AppTextVariant.body,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.l),
            AppCard(
              variant: AppCardVariant.elevated,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  children: [
                    AppText(
                      'Funkcje aplikacji',
                      variant: AppTextVariant.title,
                    ),
                    SizedBox(height: AppSpacing.s),
                    AppText(
                      '• Mapa Krakowa z OpenStreetMap\n• Generyczne komponenty UI\n• Material 3 theming\n• Responsywny design',
                      variant: AppTextVariant.body,
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
}
