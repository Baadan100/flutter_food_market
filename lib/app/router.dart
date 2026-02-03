import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/catalog/presentation/catalog_page.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const CatalogPage(),
    ),
  ],
);
