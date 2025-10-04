part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode mode;
  final bool useDynamic;
  final Color seed;

  const ThemeState({
     this.mode = ThemeMode.system,
     this.useDynamic = true,
     this.seed = AppConstants.defaultSeed,
  });

  ThemeState copyWith({
    ThemeMode? mode,
    bool? useDynamic,
    Color? seed,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      useDynamic: useDynamic ?? this.useDynamic,
      seed: seed ?? this.seed,
    );
  }

  @override
  List<Object> get props => [mode, useDynamic, seed];
}