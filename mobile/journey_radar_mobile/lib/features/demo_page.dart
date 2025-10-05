import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _decimalController = TextEditingController();

  String? _selectedCountry;
  String? _selectedCity;

  @override
  void dispose() {
    _textController.dispose();
    _numberController.dispose();
    _decimalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo - Generyczne komponenty'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Fields Section
            AppText(
              'Pola tekstowe',
              variant: AppTextVariant.headline,
            ),
            SizedBox(height: AppSpacing.m),

            AppCard(
              child: Column(
                children: [
                  AppText(
                    'Tryby pól tekstowych',
                    variant: AppTextVariant.title,
                  ),
                  SizedBox(height: AppSpacing.s),

                  // Text field
                  AppTextField(
                    label: 'Tekst (domyślny)',
                    hint: 'Wpisz dowolny tekst',
                    controller: _textController,
                    variant: AppTextFieldVariant.outlined,
                    mode: AppTextFieldMode.text,
                  ),
                  SizedBox(height: AppSpacing.s),

                  // Integer field
                  AppTextField(
                    label: 'Liczba całkowita',
                    hint: 'Wpisz liczbę całkowitą',
                    controller: _numberController,
                    variant: AppTextFieldVariant.outlined,
                    mode: AppTextFieldMode.integer,
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                  SizedBox(height: AppSpacing.s),

                  // Decimal field
                  AppTextField(
                    label: 'Liczba dziesiętna',
                    hint: 'Wpisz liczbę dziesiętną',
                    controller: _decimalController,
                    variant: AppTextFieldVariant.outlined,
                    mode: AppTextFieldMode.decimal,
                    prefixIcon: const Icon(Icons.calculate),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.l),

            // Dropdowns Section
            AppText(
              'Listy rozwijane',
              variant: AppTextVariant.headline,
            ),
            SizedBox(height: AppSpacing.m),

            AppCard(
              child: Column(
                children: [
                  AppText(
                    'Przykłady dropdownów',
                    variant: AppTextVariant.title,
                  ),
                  SizedBox(height: AppSpacing.s),

                  // Country dropdown
                  AppDropdown<String>(
                    label: 'Kraj',
                    hint: 'Wybierz kraj',
                    value: _selectedCountry,
                    onChanged: (value) {
                      setState(() {
                        _selectedCountry = value;
                      });
                    },
                    items: [
                      AppDropdownItem(
                        value: 'pl',
                        text: 'Polska',
                        icon: Icons.flag,
                      ),
                      AppDropdownItem(
                        value: 'de',
                        text: 'Niemcy',
                        icon: Icons.flag,
                      ),
                      AppDropdownItem(
                        value: 'fr',
                        text: 'Francja',
                        icon: Icons.flag,
                      ),
                      AppDropdownItem(
                        value: 'gb',
                        text: 'Wielka Brytania',
                        icon: Icons.flag,
                      ),
                    ],
                    variant: AppDropdownVariant.outlined,
                  ),
                  SizedBox(height: AppSpacing.s),

                  // City dropdown
                  AppDropdown<String>(
                    label: 'Miasto',
                    hint: 'Wybierz miasto',
                    value: _selectedCity,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    items: [
                      AppDropdownItem(
                        value: 'warsaw',
                        text: 'Warszawa',
                        icon: Icons.location_city,
                      ),
                      AppDropdownItem(
                        value: 'krakow',
                        text: 'Kraków',
                        icon: Icons.location_city,
                      ),
                      AppDropdownItem(
                        value: 'gdansk',
                        text: 'Gdańsk',
                        icon: Icons.location_city,
                      ),
                      AppDropdownItem(
                        value: 'wroclaw',
                        text: 'Wrocław',
                        icon: Icons.location_city,
                      ),
                    ],
                    variant: AppDropdownVariant.filled,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.l),

            // Buttons Section
            AppText(
              'Przyciski',
              variant: AppTextVariant.headline,
            ),
            SizedBox(height: AppSpacing.m),

            AppCard(
              child: Column(
                children: [
                  AppText(
                    'Różne warianty przycisków',
                    variant: AppTextVariant.title,
                  ),
                  SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Primary',
                          variant: AppButtonVariant.primary,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: AppButton(
                          text: 'Secondary',
                          variant: AppButtonVariant.secondary,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Text',
                          variant: AppButtonVariant.text,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: AppButton(
                          text: 'Z ikoną',
                          variant: AppButtonVariant.primary,
                          icon: Icons.save,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.l),

            // Icons Section
            AppText(
              'Ikony',
              variant: AppTextVariant.headline,
            ),
            SizedBox(height: AppSpacing.m),

            AppCard(
              child: Column(
                children: [
                  AppText(
                    'Różne warianty ikon',
                    variant: AppTextVariant.title,
                  ),
                  SizedBox(height: AppSpacing.s),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppIcon(
                        icon: Icons.favorite,
                        variant: AppIconVariant.primary,
                        onPressed: () {},
                        tooltip: 'Ulubione',
                      ),
                      AppIcon(
                        icon: Icons.star,
                        variant: AppIconVariant.secondary,
                        onPressed: () {},
                        tooltip: 'Gwiazdka',
                      ),
                      AppIcon(
                        icon: Icons.error,
                        variant: AppIconVariant.error,
                        onPressed: () {},
                        tooltip: 'Błąd',
                      ),
                      AppIcon(
                        icon: Icons.check_circle,
                        variant: AppIconVariant.success,
                        onPressed: () {},
                        tooltip: 'Sukces',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.l),

            // Avatars Section
            AppText(
              'Awatary',
              variant: AppTextVariant.headline,
            ),
            SizedBox(height: AppSpacing.m),

            AppCard(
              child: Column(
                children: [
                  AppText(
                    'Różne rozmiary awatarów',
                    variant: AppTextVariant.title,
                  ),
                  SizedBox(height: AppSpacing.s),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppAvatar(
                        initials: 'AB',
                        size: AppAvatarSize.small,
                      ),
                      AppAvatar(
                        initials: 'CD',
                        size: AppAvatarSize.medium,
                      ),
                      AppAvatar(
                        initials: 'EF',
                        size: AppAvatarSize.large,
                      ),
                      AppAvatar(
                        icon: Icons.person,
                        size: AppAvatarSize.extraLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
