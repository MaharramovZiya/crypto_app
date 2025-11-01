class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static const String apiKey = 'CG-16syNeSS1QcnUzxfopBCnmNx';
  
  // App Constants
  static const String appName = 'Crypt';
  static const String appTagline = 'Jump start your crypto portfolio';
  static const String appSmallTagLine = 'Take your investment portfolio\n to next level';
  static const String appVersion = '1.0.0';
  static const String appButtonLabel = 'Get Started';
  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  
  // Cache
  static const int cacheMaxAge = 300; // 5 minutes
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
