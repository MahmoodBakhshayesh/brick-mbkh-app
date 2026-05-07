import 'dart:developer';

import '/core/navigation/app_routes.dart';
import '/features/home/home_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../features/login/login_view.dart';
import '../../features/profile/profile_view.dart';
import '../data/app_data.dart';
import 'app_middlewares.dart';
import 'app_route_names.dart';


final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: AppRoutes.rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: AppData.instance,
    redirect: AppMiddlewares.authRoutesMiddleware,
    routes: [
      GoRoute(
        path: "/login",
        name: AppRouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: "/home",
        name: AppRouteNames.home,
        builder: (context, state) => const HomeView(),
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              final recipeId = state.pathParameters['id'];
              if (recipeId == null) {
                return child;
              }
              return ProviderScope(
                overrides: [
                  // selectedIdProvider.overrideWithValue(recipeId),
                ],
                child: child,
              );
            },
            routes: [
              // GoRoute(
              //   path: ':id/details',
              //   name: AppRouteNames.details,
              //   builder: (context, state) => const DetailsView(),
              //   routes: [
              //   ],
              // ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/profile",
        name: AppRouteNames.profile,
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
});
