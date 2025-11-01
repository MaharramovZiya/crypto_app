// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: unused_element
CryptoCoinModel _$CryptoCoinModelFromJson(Map<String, dynamic> json) =>
    CryptoCoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      marketCapRank: (json['market_cap_rank'] as num).toInt(),
      priceChange24h: (json['price_change24h'] as num).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage24h'] as num)
          .toDouble(),
      marketCapChange24h: (json['market_cap_change24h'] as num).toDouble(),
      marketCapChangePercentage24h:
          (json['market_cap_change_percentage24h'] as num).toDouble(),
      totalVolume: (json['total_volume'] as num).toDouble(),
      high24h: (json['high24h'] as num).toDouble(),
      low24h: (json['low24h'] as num).toDouble(),
      ath: (json['ath'] as num).toDouble(),
      athChangePercentage: (json['ath_change_percentage'] as num).toDouble(),
      athDate: DateTime.parse(json['ath_date'] as String),
      atl: (json['atl'] as num).toDouble(),
      atlChangePercentage: (json['atl_change_percentage'] as num).toDouble(),
      atlDate: DateTime.parse(json['atl_date'] as String),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      sparkline7d: (json['sparkline7d'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$CryptoCoinModelToJson(CryptoCoinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'current_price': instance.currentPrice,
      'market_cap': instance.marketCap,
      'market_cap_rank': instance.marketCapRank,
      'price_change24h': instance.priceChange24h,
      'price_change_percentage24h': instance.priceChangePercentage24h,
      'market_cap_change24h': instance.marketCapChange24h,
      'market_cap_change_percentage24h': instance.marketCapChangePercentage24h,
      'total_volume': instance.totalVolume,
      'high24h': instance.high24h,
      'low24h': instance.low24h,
      'ath': instance.ath,
      'ath_change_percentage': instance.athChangePercentage,
      'ath_date': instance.athDate.toIso8601String(),
      'atl': instance.atl,
      'atl_change_percentage': instance.atlChangePercentage,
      'atl_date': instance.atlDate.toIso8601String(),
      'last_updated': instance.lastUpdated.toIso8601String(),
      'sparkline7d': instance.sparkline7d,
    };
