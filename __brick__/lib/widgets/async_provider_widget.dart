import 'dart:developer';

import '/core/extensions/context_extension.dart';
import '/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show ProviderListenable, ProviderOrFamily;

class AsyncProviderWidget<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget Function(T? value) builder;

  const AsyncProviderWidget({super.key, required this.provider, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);
    log('build AsyncProviderWidget<$T> ${provider.runtimeType}');
    if (asyncValue.isRefreshing) {
      return SpinKitCircle(size: 40, color: context.mainColor);
    }
    if (asyncValue.isReloading) {
      return SpinKitCircle(size: 40, color: context.mainColor);
    }
    switch (asyncValue) {
      case AsyncData(:final value):
        return builder(value);
      case AsyncLoading():
        return SpinKitCircle(size: 40, color: context.mainColor);
      case AsyncError():
        final l10n = context.localizations;
        return Center(
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${asyncValue.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    height: 30,
                    color: Colors.orange,
                    label: l10n.retry,
                    onPressed: () {
                      ref.invalidate(provider as ProviderOrFamily);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }
}
