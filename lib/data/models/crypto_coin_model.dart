import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/crypto_coin.dart';

part 'crypto_coin_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CryptoCoinModel extends CryptoCoin {
  const CryptoCoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.marketCapRank,
    required super.priceChange24h,
    required super.priceChangePercentage24h,
    required super.marketCapChange24h,
    required super.marketCapChangePercentage24h,
    required super.totalVolume,
    required super.high24h,
    required super.low24h,
    required super.ath,
    required super.athChangePercentage,
    required super.athDate,
    required super.atl,
    required super.atlChangePercentage,
    required super.atlDate,
    required super.lastUpdated,
    super.sparkline7d,
  });

  factory CryptoCoinModel.fromJson(Map<String, dynamic> json) {
    // Check if this is from /coins/{id} endpoint (has market_data) or /coins/markets (flat structure)
    final hasMarketData = json['market_data'] != null;
    
    // Extract image - can be string (markets) or object (coin detail)
    String imageUrl = '';
    if (json['image'] is String) {
      imageUrl = json['image'] as String;
    } else if (json['image'] is Map) {
      final imageMap = json['image'] as Map<String, dynamic>;
      imageUrl = (imageMap['large'] ?? imageMap['small'] ?? imageMap['thumb'] ?? '') as String;
    }
    
    // Extract market data
    final marketData = hasMarketData ? json['market_data'] as Map<String, dynamic> : json;
    final marketDataUsd = hasMarketData && marketData['current_price'] is Map
        ? (marketData['current_price'] as Map<String, dynamic>)['usd']
        : marketData['current_price'];
    
    // Extract sparkline - can be in different locations
    List<double>? sparkline;
    if (json['sparkline_in_7d'] != null && json['sparkline_in_7d']['price'] != null) {
      sparkline = (json['sparkline_in_7d']['price'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    } else if (marketData['sparkline_7d'] != null && marketData['sparkline_7d']['price'] != null) {
      sparkline = (marketData['sparkline_7d']['price'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }
    
    return CryptoCoinModel(
      id: json['id'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: imageUrl,
      currentPrice: (marketDataUsd as num?)?.toDouble() ?? 0.0,
      marketCap: _getNestedValue(marketData, 'market_cap', 'usd') ?? 0.0,
      marketCapRank: json['market_cap_rank'] as int? ?? 0,
      priceChange24h: _getNestedValue(marketData, 'price_change_24h', 'usd') ?? 0.0,
      priceChangePercentage24h: _getNestedValue(marketData, 'price_change_percentage_24h', 'usd') ?? 0.0,
      marketCapChange24h: _getNestedValue(marketData, 'market_cap_change_24h', 'usd') ?? 0.0,
      marketCapChangePercentage24h: _getNestedValue(marketData, 'market_cap_change_percentage_24h', 'usd') ?? 0.0,
      totalVolume: _getNestedValue(marketData, 'total_volume', 'usd') ?? 0.0,
      high24h: _getNestedValue(marketData, 'high_24h', 'usd') ?? 0.0,
      low24h: _getNestedValue(marketData, 'low_24h', 'usd') ?? 0.0,
      ath: _getNestedValue(marketData, 'ath', 'usd') ?? 0.0,
      athChangePercentage: _getNestedValue(marketData, 'ath_change_percentage', 'usd') ?? 0.0,
      athDate: _parseDate(_getValue(marketData, 'ath_date', 'usd')) ?? DateTime.now(),
      atl: _getNestedValue(marketData, 'atl', 'usd') ?? 0.0,
      atlChangePercentage: _getNestedValue(marketData, 'atl_change_percentage', 'usd') ?? 0.0,
      atlDate: _parseDate(_getValue(marketData, 'atl_date', 'usd')) ?? DateTime.now(),
      lastUpdated: DateTime.tryParse((hasMarketData ? marketData['last_updated'] : json['last_updated']) as String? ?? '') ?? DateTime.now(),
      sparkline7d: sparkline,
    );
  }
  
  static double? _getNestedValue(Map<String, dynamic> data, String key, String currency) {
    final value = data[key];
    if (value == null) return null;
    
    // If it's a Map (from /coins/{id}), get the USD value
    if (value is Map<String, dynamic>) {
      return (value[currency] as num?)?.toDouble();
    }
    
    // If it's a direct number (from /coins/markets), return it
    if (value is num) {
      return value.toDouble();
    }
    
    return null;
  }
  
  static dynamic _getValue(Map<String, dynamic> data, String key, String currency) {
    final value = data[key];
    if (value == null) return null;
    
    // If it's a Map (from /coins/{id}), get the USD value
    if (value is Map<String, dynamic>) {
      return value[currency];
    }
    
    // If it's a direct value (from /coins/markets), return it
    return value;
  }
  
  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;
    if (dateValue is String) {
      return DateTime.tryParse(dateValue);
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$CryptoCoinModelToJson(this);
}
