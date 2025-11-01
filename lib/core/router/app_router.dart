import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/crypto_detail_page.dart';
import '../../presentation/pages/main_wrapper.dart';
import '../../presentation/pages/splash_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String main = '/main';
  static const String cryptoDetail = '/crypto-detail';

  static final GoRouter router = GoRouter(
    initialLocation: main,
    debugLogDiagnostics: true,
    routes: [
      // Splash Route
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Main Wrapper Route (with bottom navigation)
      GoRoute(
        path: main,
        name: 'main',
        builder: (context, state) => const MainWrapper(),
      ),
      
      // Crypto Detail Route
      GoRoute(
        path: '$cryptoDetail/:id',
        name: 'crypto-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CryptoDetailPage(cryptoId: id);
        },
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(main),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
