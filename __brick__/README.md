# {{project_name}}

Generated with the `mbkh_app` Mason brick.

- API origin: `{{base_url}}` → REST base `{{base_url}}/api/`
- Primary color: `#{{primary_color}}` → `AppColors.primaryColor` and `AppColors.actions`

## Included

- MBKH feature-first folder structure
- Core/helpers/interfaces/controllers/widgets baseline files
- Core navigation scaffold
- Per-feature DI (`login_di.dart`, `profile_di.dart`) + aggregators
- `.cursor/rules` starter rules
- Seeded features: login, home, profile
- `unified_fields` v1 integration with `{{project_name}}_field_decoration.dart`
- fa-first localization with `FailureLocalizer`

## Next steps

1. Run `flutter create .` in this folder (if platforms are not yet present).
2. Run `flutter pub get`.
3. Run the app.
4. Use the `mbkh_feat` brick for new features (see `WIRING_REQUIRED.md`).
