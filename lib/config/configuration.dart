import 'package:crypto_app/ui/theme/dark_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_constants.dart';

class Configuration {
  static Configuration? _instance;
  static Configuration get instance => _instance ??= Configuration._internal();
  
  Configuration._internal();

  // Environment
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  
  // API Configuration
  String get baseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.coingecko.com/api/v3';
      case 'staging':
        return 'https://api.coingecko.com/api/v3';
      default:
        return AppConstants.baseUrl;
    }
  }
  
  String get apiKey {
    switch (environment) {
      case 'production':
        return const String.fromEnvironment('API_KEY', defaultValue: AppConstants.apiKey);
      case 'staging':
        return const String.fromEnvironment('API_KEY', defaultValue: AppConstants.apiKey);
      default:
        return AppConstants.apiKey;
    }
  }
  
  // App Configuration
  String get appName => AppConstants.appName;
  String get appVersion => AppConstants.appVersion;
  
  // Timeouts
  int get connectTimeout => AppConstants.connectTimeout;
  int get receiveTimeout => AppConstants.receiveTimeout;
  int get sendTimeout => AppConstants.sendTimeout;
  
  // Cache
  int get cacheMaxAge => AppConstants.cacheMaxAge;
  
  // Pagination
  int get defaultPageSize => AppConstants.defaultPageSize;
  int get maxPageSize => AppConstants.maxPageSize;
  
  // Debug
  bool get isDebugMode => kDebugMode;
  bool get isReleaseMode => kReleaseMode;
  
  // Logging
  bool get enableLogging => isDebugMode;
  
  // Theme Configuration
  ThemeData get appTheme => darkTheme;
  
  // System UI Configuration
  void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF1A1A1A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
}
