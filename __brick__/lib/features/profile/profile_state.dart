import 'dart:ui';
import 'package:hooks_riverpod/legacy.dart';


// final loadingProfile = StateProvider<bool>((ref) => false);
final localizationProvider = StateProvider<Locale>((ref) => Locale('fa'));
final settingAvatarProvider = StateProvider<bool>((ref) =>false);
