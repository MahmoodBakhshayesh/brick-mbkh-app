import 'package:{{project_name}}/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:unified_fields/unified_fields.dart';

/// App-wide [UnifiedInputThemeScope] for forms, pickers, and sheets.
class UnifiedInputThemeShell extends StatelessWidget {
  final Widget child;

  const UnifiedInputThemeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UnifiedInputThemeScope(
      data: _themeData,
      brightnessOverride: UnifiedInputBrightness.dark,
      paletteOverride: _palette,
      child: child,
    );
  }

  static final UnifiedInputThemeData _themeData = UnifiedInputThemeData(
    disabledFieldBackgroundOpacity: 0.4,
    fieldDefaults: UnifiedInputFieldDefaults(
      labelMode: UnifiedFieldLabelMode.labelInColumn,
      textStyle: const TextStyle(fontFamily: 'Yekan', color: AppColors.textColorDark),
      textStylePersian: const TextStyle(fontFamily: 'Yekan', color: AppColors.textColorDark),
      placeholderStyle: const TextStyle(fontFamily: 'Yekan'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    ),
    multiPickerCheckboxStyle: const UnifiedInputMultiPickerCheckboxStyle(
      borderColor: Colors.black54,
    ),
    pickerHeaderStyle: const UnifiedInputPickerHeaderStyle(
      titleStyle: TextStyle(color: AppColors.textColorDark, fontSize: 16),
      padding: EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 8),
    ),
    pickerSheetBackgroundColor: AppColors.scaffoldBackgroundColorDark,
  );

  static final UnifiedInputPalette _palette = UnifiedInputPalette(
    bodyBackground: AppColors.black24,
    headerBackground: AppColors.black24,
    labelColor: AppColors.textColorDark,
    hintColor: AppColors.hintColor,
    fieldTextColor: AppColors.textColorDark,
    borderColor: AppColors.borderColor,
    defaultBorderSide: const BorderSide(color: AppColors.borderColor2, width: 0.5),
    borderRadius: BorderRadius.circular(16),
    validationColor: Colors.red,
    sheetBackground: AppColors.scaffoldBackgroundColorDark,
    sheetHeaderBackground: AppColors.scaffoldBackgroundColorDark,
  );
}
