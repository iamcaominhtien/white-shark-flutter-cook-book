part of 'date_picker_inherited_widget.dart';

extension TextThemeDatePicker on DatePicker {
  TextStyle? get headlineLarge =>
      Theme.of(_context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: _primaryColor,
          fontSize:
              (Theme.of(_context).textTheme.headlineLarge?.fontSize ?? 20) *
                  1.3);

  TextStyle? get headlineMedium => Theme.of(_context)
      .textTheme
      .headlineMedium
      ?.copyWith(color: _primaryColor);

  TextStyle? get headlineSmall => Theme.of(_context)
      .textTheme
      .headlineSmall
      ?.copyWith(color: _primaryColor);

  TextStyle? get titleLarge => Theme.of(_context)
      .textTheme
      .titleLarge
      ?.copyWith(color: _primaryColor, fontWeight: FontWeight.w600);

  TextStyle? get titleMedium => Theme.of(_context)
      .textTheme
      .titleMedium
      ?.copyWith(color: _primaryColor, fontWeight: FontWeight.w600);

  TextStyle? get titleSmall =>
      Theme.of(_context).textTheme.titleSmall?.copyWith(color: _primaryColor);

  TextStyle? get bodyLarge =>
      Theme.of(_context).textTheme.bodyLarge?.copyWith(color: _primaryColor);

  TextStyle? get bodyMedium =>
      Theme.of(_context).textTheme.bodyMedium?.copyWith(color: _primaryColor);

  TextStyle? get bodySmall =>
      Theme.of(_context).textTheme.bodySmall?.copyWith(color: _primaryColor);

  Color get _primaryColor => Theme.of(_context).colorScheme.primary;
}
