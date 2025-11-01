import 'package:flutter/material.dart';

import '../config/configuration.dart';
import '../core/router/app_router.dart';
import '../providers/provider_scope.dart';

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    Configuration.instance.setSystemUIOverlayStyle();

    return ProviderScope(
      child: MaterialApp.router(
        title: Configuration.instance.appName,
        debugShowCheckedModeBanner: false,
        theme: Configuration.instance.appTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
